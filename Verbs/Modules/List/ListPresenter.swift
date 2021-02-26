//
//  ListPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListPresenter: NSObject {
    
    var dataSource: VerbsSectionDataSource?
    weak var viewController: ListViewController?
    var router: ListRouter?
    
    var isEditing = false
    var hasTranslation: Bool { languageService.hasTranslation }
    var favoritesOnly: Bool { verbsService.favoritesOnly }
    
    private let languageService: LanguageService
    private let verbsService: VerbsServiceProtocol
    private let printService: PrintService
    
    private var infinitive: String?
    
    private var isSearchActive: Bool {
        get { dataSource?.isSearchActive ?? false }
        set { dataSource?.isSearchActive = newValue }
    }
    
    init(languageService: LanguageService,
         verbsService: VerbsServiceProtocol,
         printService: PrintService) {
        self.languageService = languageService
        self.verbsService = verbsService
        self.printService = printService
        
        super.init()
        
        self.dataSource = .init(verbsService: verbsService,
                                hasTranslation: languageService.hasTranslation,
                                setStateBlock: setState)
        
        loadSettings()
        subscribe()
        setState()
    }
    
    func selectWhenRegular() {
        let neededViewController = viewController?.splitViewController?.secondaryViewController?.topViewController
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        guard let title = neededViewController?.navigationItem.title else { return }
        infinitive = title
        didSelectedItemSet()
    }
    
    func updateRegulars(_ value: Bool) {
        verbsService.shouldRegularVerbsBeShown = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    func updateDerivatives(_ value: Bool) {
        verbsService.shouldDerivativesBeShown = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    func print() {
        printService.print(verbsService.items, hasTranslation: languageService.hasTranslation)
    }
}

// MARK: - Private

private extension ListPresenter {
    
    var items: [Verb] {
        !isSearchActive ? verbsService.items : verbsService.searchedItems
    }
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        verbsService.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        verbsService.shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectedItemUpdate),
                                               name: .infinitive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: .reload,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willUpdateList),
                                               name: .list,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willReloadData),
                                               name: .favorites,
                                               object: nil)
    }
    
    func setState() {
        let state = ListState(isSearchActive: isSearchActive,
                              isSearchTextEmpty: verbsService.searchText.isEmpty,
                              areItemsEmpty: items.isEmpty)
        viewController?.setState(state)
    }
    
    func didSelectedItemSet() {
        guard !isSearchActive,
              viewController?.splitViewController?.isCollapsed == false else { return }
        
        let indexPath = verbsService.indexPath(of: infinitive)
        viewController?.selectRow(at: indexPath)
    }
    
    @objc func didSelectedItemUpdate(_ notification: Notification) {
        infinitive = notification.userInfo?[Notification.Name.infinitive] as? String ?? ""
        didSelectedItemSet()
    }
    
    @objc func didPay(_ notification: Notification) {
        viewController?.getPaid()
    }
    
    @objc func willUpdateList(_ notification: Notification) {
        let value = notification.userInfo?[Notification.Name.list] as? Bool ?? false
        verbsService.shouldTranslationBeShown = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    @objc func willReloadData(_ notification: Notification) {
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    func handleMenuAction(verb: Verb, isFavorite: Bool) {
        if isFavorite {
            Locator.favorites.remove(verb)
        } else {
            guard !Locator.favorites.shouldPaywallBeShown else {
                router?.goToPaywall()
                return
            }
            
            Locator.favorites.add(verb)
        }
    }
    
    func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        let verb = verbsService.groupedItems[indexPath.section][indexPath.row]
        guard !Locator.favorites.verbs.contains(verb) else { return [] }
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: VerbDragItem(verb: verb)))
        dragItem.localObject = verb
        return [dragItem]
    }
}

// MARK: - UITableViewDelegate

extension ListPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let verb = !isSearchActive
            ? verbsService.groupedItems[indexPath.section][indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        
        guard infinitive != verb.infinitive.value else { return }
        router?.goToDetail(with: verb)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        guard !isSearchActive,
              let verb = verbsService.groupedItems[safe: indexPath.section]?[safe: indexPath.row] else { return nil }
        let isFavorite = Locator.favorites.verbs.contains(verb)
        
        let actionProvider: UIContextMenuActionProvider = { [weak self] _ in
            let action: UIAction
                
            switch (self?.favoritesOnly, isFavorite) {
            case (true, _):
                action =  .init(title: "remove".localized, image: SystemIcon.starSlash.image) { [weak self] _ in
                    self?.handleMenuAction(verb: verb, isFavorite: isFavorite)
                }
            case (_, true):
                action = .init(title: "remove_from_favorites".localized, image: SystemIcon.starSlash.image) { [weak self] _ in
                    self?.handleMenuAction(verb: verb, isFavorite: isFavorite)
                }
            case (_, false):
                action = .init(title: "add_to_favorites".localized, image: SystemIcon.star.image) { [weak self] _ in
                    self?.handleMenuAction(verb: verb, isFavorite: isFavorite)
                }
            }
                
            return .init(children: [action])
        }
        
        let previewProvider: UIContextMenuContentPreviewProvider = { [weak self] in
            guard let nvc = self?.viewController?.navigationController else { return nil }
            return DetailAssembly(verb: verb,
                                  isOpenedByDeeplink: false,
                                  navigationController: nvc).viewController()
        }
        
        let svc = viewController?.splitViewController
        let isCompact = svc?.traitCollection.horizontalSizeClass == .compact
        
        return .init(identifier: indexPath as NSIndexPath,
                     previewProvider: isCompact ? previewProvider : nil,
                     actionProvider: actionProvider)
    }
    
    func tableView(_ tableView: UITableView,
                   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                   animator: UIContextMenuInteractionCommitAnimating) {
        let svc = viewController?.splitViewController
        let isCompact = svc?.traitCollection.horizontalSizeClass == .compact
        guard isCompact, let indexPath = configuration.identifier as? IndexPath else { return }
        let verb = verbsService.groupedItems[indexPath.section][indexPath.row]
        animator.addAnimations { self.router?.goToDetail(with: verb) }
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard favoritesOnly else { return nil }
        
        let removeAction = UIContextualAction(style: .destructive, title: "remove".localized) { [weak self] _, _, _ in
            guard let self = self, !self.isSearchActive,
                  let verb = self.verbsService.groupedItems[safe: indexPath.section]?[indexPath.row]
            else { return }
            
            Locator.favorites.remove(verb)
            tableView.reloadData()
        }
        
        removeAction.backgroundColor = tableView.tintAdjustmentMode != .dimmed ? .systemRed : .systemGray
        return .init(actions: [removeAction])
    }
}

// MARK: - UITableViewDragDelegate

extension ListPresenter: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        guard !favoritesOnly,
              !isSearchActive,
              viewController?.splitViewController?.isCollapsed == false else { return [] }
        session.localContext = tableView
        return dragItems(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForAddingTo session: UIDragSession,
                   at indexPath: IndexPath,
                   point: CGPoint) -> [UIDragItem] {
        guard !favoritesOnly,
              !isSearchActive,
              viewController?.splitViewController?.isCollapsed == false else { return [] }
        return dragItems(at: indexPath)
    }
}

// MARK: - UISearchResultsUpdating

extension ListPresenter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        verbsService.searchText = searchText
        viewController?.reloadData()
    }
}

// MARK: - UISearchControllerDelegate

extension ListPresenter: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        isSearchActive = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        isSearchActive = false
        searchController.searchBar.resignFirstResponder()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        didSelectedItemSet()
    }
}
