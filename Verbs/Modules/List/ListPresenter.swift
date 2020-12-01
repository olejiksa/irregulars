//
//  ListPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListPresenter: NSObject {
    
    weak var viewController: ListViewController?
    var router: ListRouter?
    
    private let languageService: LanguageService
    private let verbsService: VerbsService
    private var isSearchActive = false
    
    private var infinitive: String?
    
    init(languageService: LanguageService,
         verbsService: VerbsService) {
        self.languageService = languageService
        self.verbsService = verbsService
        
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
}

// MARK: - Private

private extension ListPresenter {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.standard.bool(for: .shouldRegularVerbsBeShown)
        verbsService.shouldDerivedFormsBeShown = UserDefaults.standard.bool(for: .shouldDerivedFormsBeShown)
        verbsService.shouldTranslationBeShown = UserDefaults.standard.bool(for: .shouldTranslationBeShown)
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
        let value = notification.userInfo?[Notification.Name.list] as? Bool ?? false
        verbsService.shouldTranslationBeShown = value
        viewController?.reloadData()
        didSelectedItemSet()
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
        let item: ItemProtocol = !verbsService.shouldTranslationBeShown || !languageService.hasTranslation ?
            ListItem(verb: verb) :
            SubtitleItem(title: verb.infinitive.value, subtitle: verb.translation)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isSearchActive else { return nil }
        let items = verbsService.groupedItems[section]
        guard let letter = items.first?.infinitive.value.first else { return nil }
        return letter.uppercased()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard !isSearchActive else { return nil }
        let set = Set(verbsService.items.compactMap { item -> String? in
            guard let character = item.infinitive.value.first else { return nil }
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
        
        guard infinitive != verb.infinitive.value else { return }
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
