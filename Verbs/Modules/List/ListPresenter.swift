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
    
    weak var viewController: ListViewController?
    var router: ListRouter?
    
    init(verbsService: VerbsService,
         userDefaultsService: UserDefaultsService) {
        self.verbsService = verbsService
        self.userDefaultsService = userDefaultsService
        
        super.init()
        
        verbsService.shouldRegularVerbsBeShown = userDefaultsService.load()?.isOn ?? true
    }
    
    @objc func goToSettings() {
        let shouldRegularVerbsBeShownBlock: ((Bool) -> ()) = { [weak self] in
            guard let self = self else { return }
            
            self.verbsService.shouldRegularVerbsBeShown = $0
            self.viewController?.reloadData()
        }
                                             
        router?.goToSettings(with: shouldRegularVerbsBeShownBlock)
    }
}

// MARK: - UITableViewDataSource

extension ListPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = !(isSearchActive && FeatureToggle.isPaid)
            ? verbsService.groupedItems.count
            : (verbsService.searchedItems.count > 0 ? 1 : 0)
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !(isSearchActive && FeatureToggle.isPaid)
            ? verbsService.groupedItems[section].count
            : verbsService.searchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let verb = !(isSearchActive && FeatureToggle.isPaid)
            ? verbsService.groupedItems[indexPath.section][indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        let item = ListItem(verb: verb)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isSearchActive && FeatureToggle.isPaid else { return nil }
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
        let verb = !isSearchActive
            ? verbsService.groupedItems[indexPath.section][indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        
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
}
