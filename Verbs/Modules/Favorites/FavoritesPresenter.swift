//
//  FavoritesPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class FavoritesPresenter: NSObject {
    
    weak var viewController: FavoritesViewController?
    var router: FavoritesRouter?
    
    var isEditing = false
    var hasTranslation: Bool { languageService.hasTranslation }
    
    private let languageService: LanguageService
    private let favoritesService: FavoritesService
    private let printService: PrintService
    private var favorites = Locator.favorites
    private var isSearchActive = false
    
    private var infinitive: String?
    
    init(languageService: LanguageService,
         favoritesService: FavoritesService,
         printService: PrintService) {
        self.languageService = languageService
        self.favoritesService = favoritesService
        self.printService = printService
        
        super.init()
        
        loadSettings()
        subscribe()
    }
    
    func selectWhenRegular() {
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        guard let title = viewController?.splitViewController?.secondaryViewController?.topViewController?.navigationItem.title else { return }
        infinitive = title
        didSelectedItemSet()
    }
    
    func print() {
        printService.print(favoritesService.items,
                           hasTranslation: languageService.hasTranslation)
    }
}

// MARK: - Private

private extension FavoritesPresenter {
    
    var items: [Verb] {
        !isSearchActive ? favoritesService.items : favoritesService.searchedItems
    }
    
    func loadSettings() {
        favoritesService.shouldTranslationBeShown = UserDefaults.shared.bool(for: .shouldTranslationBeShown)
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectedItemUpdate),
                                               name: Notification.Name.infinitive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.reload,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willUpdateList),
                                               name: Notification.Name.list,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willReloadData),
                                               name: Notification.Name.favorites,
                                               object: nil)
    }
    
    func setState() {
        let state: ListState = isSearchActive || items.count > 0 ? .data : .empty
        viewController?.setState(state)
    }
    
    func didSelectedItemSet() {
        guard !isSearchActive,
              viewController?.splitViewController?.isCollapsed == false else { return }
        
        let indexPath = favoritesService.indexPath(of: infinitive)
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
        favoritesService.shouldTranslationBeShown = value
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

// MARK: - UITableViewDataSource

extension FavoritesPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = !isSearchActive
            ? favoritesService.groupedItems.count
            : (favoritesService.searchedItems.count > 0 ? 1 : 0)
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        setState()
        return max(count, 1)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !isSearchActive
            ? favoritesService.groupedItems[safe: section]?.count ?? 0
            : favoritesService.searchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let verb = !isSearchActive
            ? favoritesService.groupedItems[safe: indexPath.section]?[indexPath.row]
            : favoritesService.searchedItems[indexPath.row] else { return .init() }
        let item: ItemProtocol = !favoritesService.shouldTranslationBeShown || !languageService.hasTranslation ?
            ListItem(verb: verb) :
            SubtitleItem(title: verb.infinitive.value, subtitle: verb.translation)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isSearchActive else { return nil }
        let items = favoritesService.groupedItems[safe: section]
        guard let letter = items?.first?.infinitive.value.first else { return nil }
        return letter.uppercased()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard !isSearchActive else { return nil }
        let set = Set(favoritesService.items.compactMap { item -> String? in
            guard let character = item.infinitive.value.first else { return nil }
            return character.uppercased()
        })
        
        return Array(set).sorted()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard !isSearchActive else { return false }
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(style: .destructive,
                                              title: "remove".localized) { [weak self] _, _, _ in
            guard let self = self,
                  !self.isSearchActive,
                  let verb = self.favoritesService.groupedItems[safe: indexPath.section]?[indexPath.row]
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

// MARK: - UITableViewDelegate

extension FavoritesPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let verb = !isSearchActive
            ? favoritesService.groupedItems[indexPath.section][indexPath.row]
            : favoritesService.searchedItems[indexPath.row]
        
        guard infinitive != verb.infinitive.value else { return }
        router?.goToDetail(with: verb)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        guard !isSearchActive, !isEditing else { return nil }
        let verb = favoritesService.groupedItems[indexPath.section][indexPath.row]
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
        let verb = favoritesService.groupedItems[indexPath.section][indexPath.row]
        animator.addAnimations {
            self.router?.goToDetail(with: verb)
        }
    }
}

// MARK: - UISearchResultsUpdating

extension FavoritesPresenter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        favoritesService.searchText = searchText
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
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        didSelectedItemSet()
    }
}
