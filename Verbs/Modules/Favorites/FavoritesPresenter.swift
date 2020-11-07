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
    private let verbsService: FavoritesService
    private let userDefaultsService: UserDefaultsService
    private var isSearchActive = false
    
    private var infinitive: String? {
        didSet {
            didSelectedItemSet()
        }
    }
    
    init(languageService: LanguageService,
         verbsService: FavoritesService,
         userDefaultsService: UserDefaultsService) {
        self.languageService = languageService
        self.verbsService = verbsService
        self.userDefaultsService = userDefaultsService
        
        super.init()
        
        loadSettings()
        subscribe()
    }
    
    @objc func goToTests() {
        let vc = TestsAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
    }
    
    @objc func goToSettings() {
        router?.goToSettings()
    }
}

// MARK: - Private

private extension FavoritesPresenter {
    
    func loadSettings() {
        guard let settings = userDefaultsService.load() else { return }
        verbsService.shouldRegularVerbsBeShown = settings.shouldRegularVerbsBeShown
        verbsService.shouldDerivedFormsBeShown = settings.shouldDerivedFormsBeShown
        verbsService.listView = settings.listView
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
                                               selector: #selector(willUpdateRegulars),
                                               name: Notification.Name.regulars,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willUpdateDerivatives),
                                               name: Notification.Name.derivatives,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willUpdateList),
                                               name: Notification.Name.list,
                                               object: nil)
    }
    
    func didSelectedItemSet() {
        guard !isSearchActive else { return }
        
        let indexPath = verbsService.indexPath(of: infinitive)
        viewController?.selectRow(at: indexPath)
    }
    
    @objc func didSelectedItemUpdate(_ notification: Notification) {
        infinitive = notification.userInfo?[Notification.Name.infinitive] as? String ?? ""
    }
    
    @objc func didPay(_ notification: Notification) {
        viewController?.getPaid()
    }
    
    @objc func willUpdateRegulars(_ notification: Notification) {
        let value = notification.userInfo?[Notification.Name.regulars] as? Bool ?? false
        verbsService.shouldRegularVerbsBeShown = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    @objc func willUpdateDerivatives(_ notification: Notification) {
        let value = notification.userInfo?[Notification.Name.derivatives] as? Bool ?? false
        verbsService.shouldDerivedFormsBeShown = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
    
    @objc func willUpdateList(_ notification: Notification) {
        let value = notification.userInfo?[Notification.Name.list] as? Settings.ListView ?? .forms
        verbsService.listView = value
        viewController?.reloadData()
        didSelectedItemSet()
    }
}

// MARK: - UITableViewDataSource

extension FavoritesPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = !isSearchActive
            ? verbsService.items.count
            : (verbsService.searchedItems.count > 0 ? 1 : 0)
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !isSearchActive
            ? verbsService.items.count
            : verbsService.searchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let verb = !isSearchActive
            ? verbsService.items[indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        let item: ItemProtocol = verbsService.listView == .forms || !languageService.hasTranslation ?
            ListItem(verb: verb) :
            SubtitleItem(title: verb.infinitive.value, subtitle: verb.translation)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension FavoritesPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearchActive {
            tableView.deselectRow(at: indexPath, animated: true)
        }

        let verb = !isSearchActive
            ? verbsService.items[indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        
        guard infinitive != verb.infinitive.value else { return }
        router?.goToDetail(with: verb)
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
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        didSelectedItemSet()
    }
}
