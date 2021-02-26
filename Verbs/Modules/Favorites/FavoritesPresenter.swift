//
//  FavoritesPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FavoritesPresenter: NSObject {
    
    var dataSource: VerbsSectionDataSource?
    weak var viewController: FavoritesViewController?
    var router: FavoritesRouter?
    
    var isEditing = false
    var hasTranslation: Bool { languageService.hasTranslation }
    
    private let languageService: LanguageService
    private let verbsService: VerbsServiceProtocol
    private let printService: PrintService
    private var favorites = Locator.favorites
    
    private var isSearchActive: Bool {
        get { dataSource?.isSearchActive ?? false }
        set { dataSource?.isSearchActive = newValue }
    }
    
    private var infinitive: String?
    
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
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        guard let title = viewController?.splitViewController?.secondaryViewController?.topViewController?.navigationItem.title else { return }
        infinitive = title
        didSelectedItemSet()
    }
    
    func print() {
        printService.print(verbsService.items, hasTranslation: languageService.hasTranslation)
    }
}

// MARK: - Private

private extension FavoritesPresenter {
    
    var items: [Verb] {
        !isSearchActive ? verbsService.items : verbsService.searchedItems
    }
    
    func loadSettings() {
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
}

// MARK: - UITableViewDelegate

extension FavoritesPresenter: UITableViewDelegate {
    
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
        guard !isSearchActive, !isEditing else { return nil }
        let verb = verbsService.groupedItems[indexPath.section][indexPath.row]
        let isFavorite = Locator.favorites.verbs.contains(verb)
        
        let actionProvider: UIContextMenuActionProvider = { _ in
            let action = UIAction(title: "remove".localized,
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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive,
                                              title: "remove".localized) { [weak self] _, _, _ in
            guard let self = self,
                  !self.isSearchActive,
                  let verb = self.verbsService.groupedItems[safe: indexPath.section]?[indexPath.row]
            else { return }
            
            self.favorites.remove(verb)
            tableView.reloadData()
        }
        
        removeAction.backgroundColor = tableView.tintAdjustmentMode != .dimmed ?
            .systemRed :
            .systemGray
        return .init(actions: [removeAction])
    }
}

// MARK: - UISearchResultsUpdating

extension FavoritesPresenter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        verbsService.searchText = searchText
        viewController?.reloadData()
    }
}

// MARK: - UISearchControllerDelegate

extension FavoritesPresenter: UISearchControllerDelegate {
    
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
