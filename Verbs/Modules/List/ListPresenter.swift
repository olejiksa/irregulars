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
    
    var hasTranslation: Bool { languageService.hasTranslation }
    
    private let languageService: LanguageService
    private let verbsService: VerbsServiceProtocol
    private var printService: PrintService
    
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
        printService.print(verbsService.items,
                           hasTranslation: languageService.hasTranslation)
    }
    
    func setState() {
        let state: ListState
        switch (isSearchActive, verbsService.searchText.isEmpty, items.isEmpty) {
        case (true, false, true):
            state = .searchNotFound("Ничего не найдено".localized)
        case (true, true, true):
            state = .searchStarted("Начните набирать неправильный глагол в любой из форм или его перевод, чтобы увидеть результаты поиска".localized)
        case (_, _, false):
            state = .data
        case (false, _, true):
            state = .empty("empty_favorites".localized)
        }
        
        viewController?.setState(state)
    }
}

// MARK: - Private

private extension ListPresenter {
    
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
    
    var items: [Verb] {
        !isSearchActive ? verbsService.items : verbsService.searchedItems
    }
    
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
        guard !isSearchActive else { return nil }
        let verb = verbsService.groupedItems[indexPath.section][indexPath.row]
        let isFavorite = Locator.favorites.verbs.contains(verb)
        
        let actionProvider: UIContextMenuActionProvider = { _ in
            let action = !isFavorite ?
                UIAction(title: "add_to_favorites".localized,
                         image: SystemIcon.star.image) { [weak self] _ in
                    self?.handleMenuAction(verb: verb, isFavorite: isFavorite)
                } :
                UIAction(title: "remove_from_favorites".localized,
                         image: SystemIcon.starSlash.image) { [weak self] _ in
                    self?.handleMenuAction(verb: verb, isFavorite: isFavorite)
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
        animator.addAnimations {
            self.router?.goToDetail(with: verb)
        }
    }
}

// MARK: - UITableViewDragDelegate

extension ListPresenter: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        guard !isSearchActive,
              viewController?.splitViewController?.isCollapsed == false else { return [] }
        session.localContext = tableView
        return dragItems(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForAddingTo session: UIDragSession,
                   at indexPath: IndexPath,
                   point: CGPoint) -> [UIDragItem] {
        guard !isSearchActive,
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
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        didSelectedItemSet()
    }
}
