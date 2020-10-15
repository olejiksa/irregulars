//
//  ListPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListPresenter: NSObject {
    
    private let verbsService: VerbsService
    private let userDefaultsService: UserDefaultsService
    private var isSearchActive = false
    
    private var infinitive: String? {
        didSet {
            didSelectedItemSet()
        }
    }
    
    weak var viewController: ListViewController?
    var router: ListRouter?
    
    init(verbsService: VerbsService,
         userDefaultsService: UserDefaultsService) {
        self.verbsService = verbsService
        self.userDefaultsService = userDefaultsService
        
        super.init()
        
        loadSettings()
        subscribe()
    }
    
    deinit {
        unsubscribe()
    }
    
    @objc func goToSettings() {
        let shouldRegularVerbsBeShownBlock: ((Bool) -> ()) = { [weak self] in
            guard let self = self else { return }
            
            self.verbsService.shouldRegularVerbsBeShown = $0
            self.viewController?.reloadData()
            self.didSelectedItemSet()
        }
        
        let shouldDerivedFormsBeShownBlock: ((Bool) -> ()) = { [weak self] in
            guard let self = self else { return }
            
            self.verbsService.shouldDerivedFormsBeShown = $0
            self.viewController?.reloadData()
            self.didSelectedItemSet()
        }
                                             
        router?.goToSettings(regularVerbsBlock: shouldRegularVerbsBeShownBlock,
                             derivedFormsBlock: shouldDerivedFormsBeShownBlock)
    }
}

// MARK: - Private

private extension ListPresenter {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = userDefaultsService.load()?.shouldRegularVerbsBeShown ?? true
        verbsService.shouldDerivedFormsBeShown = userDefaultsService.load()?.shouldDerivedFormsBeShown ?? true
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectedItemUpdate),
                                               name: Notification.Name.infinitive,
                                               object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name.infinitive,
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
}

// MARK: - UITableViewDataSource

extension ListPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = !isSearchActive
            ? verbsService.groupedItems.count
            : (verbsService.searchedItems.count > 0 ? 1 : 0)
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !isSearchActive
            ? verbsService.groupedItems[section].count
            : verbsService.searchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let verb = !isSearchActive
            ? verbsService.groupedItems[indexPath.section][indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        let item = ListItem(verb: verb)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isSearchActive else { return nil }
        let items = verbsService.groupedItems[section]
        guard let letter = items.first?.infinitive.first else { return nil }
        return letter.uppercased()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard !isSearchActive && FeatureToggle.isPaid else { return nil }
        let set = Set(verbsService.items.compactMap { item -> String? in
            guard let character = item.infinitive.first else { return nil }
            return character.uppercased()
        })
        
        return Array(set).sorted()
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
        
        guard infinitive != verb.infinitive else { return }
        router?.goToDetail(with: verb)
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
