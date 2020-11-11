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
    
    private let languageService: LanguageService
    private let favoritesService: FavoritesService
    private var favorites = Locator.favorites
    private let userDefaultsService: UserDefaultsService
    private var isSearchActive = false
    
    private var infinitive: String? {
        didSet {
            didSelectedItemSet()
        }
    }
    
    init(languageService: LanguageService,
         favoritesService: FavoritesService,
         userDefaultsService: UserDefaultsService) {
        self.languageService = languageService
        self.favoritesService = favoritesService
        self.userDefaultsService = userDefaultsService
        
        super.init()
        
        loadSettings()
        subscribe()
    }
}

// MARK: - Private

private extension FavoritesPresenter {
    
    var items: [Verb] {
        !isSearchActive ? favoritesService.items : favoritesService.searchedItems
    }
    
    func loadSettings() {
        guard let settings = userDefaultsService.load() else { return }
        favoritesService.listView = settings.listView
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectedItemUpdate),
                                               name: Notification.Name.infinitive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.paid,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willUpdateList),
                                               name: Notification.Name.list,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willReloadData),
                                               name: Notification.Name.reloadData,
                                               object: nil)
    }
    
    func setState() {
        let state: ListState = isSearchActive || items.count > 0 ? .data : .empty
        viewController?.setState(state)
    }
    
    func didSelectedItemSet() {
        guard viewController?.splitViewController?.isCollapsed == false else { return }
        guard !isSearchActive else { return }
        
        let indexPath = favoritesService.indexPath(of: infinitive)
        viewController?.selectRow(at: indexPath)
    }
    
    @objc func didSelectedItemUpdate(_ notification: Notification) {
        infinitive = notification.userInfo?[Notification.Name.infinitive] as? String ?? ""
    }
    
    @objc func didPay(_ notification: Notification) {
        viewController?.getPaid()
    }
    
    @objc func willUpdateList(_ notification: Notification) {
        let value = notification.userInfo?[Notification.Name.list] as? Settings.ListView ?? .forms
        favoritesService.listView = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    @objc func willReloadData(_ notification: Notification) {
        viewController?.reloadData()
        didSelectedItemSet()
    }
}

// MARK: - UITableViewDataSource

extension FavoritesPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView.separatorStyle = items.count > 0 ? .singleLine : .none
        setState()
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let verb = items[indexPath.row]
        let item: ItemProtocol = favoritesService.listView == .forms || !languageService.hasTranslation ?
            ListItem(verb: verb) :
            SubtitleItem(title: verb.infinitive.value, subtitle: verb.translation)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard !isSearchActive, editingStyle == .delete else { return }
        tableView.beginUpdates()
        let verb = favoritesService.items[indexPath.row]
        favorites.remove(verb)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate

extension FavoritesPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let verb = favoritesService.items[indexPath.row]
        
        guard infinitive != verb.infinitive.value else { return }
        router?.goToDetail(with: verb)
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
