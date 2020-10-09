//
//  ListViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var keyboardService: KeyboardService?
    private let verbsService = VerbsService()
    private let userDefaultsService = UserDefaultsService()
    
    @IBOutlet private weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupServices()
        setupNavigationBar()
        setupTableView()
        setupSearchController()
    }
}

// MARK: - Private

private extension ListViewController {
    
    func setupServices() {
        keyboardService = .init(keyboardHeightLayoutConstraint: keyboardHeightLayoutConstraint, view: view)
        verbsService.shouldRegularVerbsBeShown = userDefaultsService.load()?.isOn ?? true
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Глаголы"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard FeatureToggle.isPaid else { return }
        
        let settings = UIBarButtonItem(image: SystemIcon.gear.image,
                                       style: .plain,
                                       target: self,
                                       action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = settings
    }
    
    func setupTableView() {
        tableView.register(ListCell.self)
    }
    
    func setupSearchController() {
        guard FeatureToggle.isPaid else { return }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    @objc func goToSettings() {
        let vc = SettingsViewController()
        vc.shouldRegularVerbsBeShownBlock = { [weak self] in
            guard let self = self else { return }
           
            self.verbsService.shouldRegularVerbsBeShown = $0
            self.tableView.reloadData()
        }
        
        let nvc = UINavigationController(rootViewController: vc)
        navigationController?.present(nvc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = !(searchController.isActive && FeatureToggle.isPaid)
            ? verbsService.groupedItems.count
            : (verbsService.searchedItems.count > 0 ? 1 : 0)
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !(searchController.isActive && FeatureToggle.isPaid)
            ? verbsService.groupedItems[section].count
            : verbsService.searchedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let verb = !(searchController.isActive && FeatureToggle.isPaid)
            ? verbsService.groupedItems[indexPath.section][indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        let item = ListItem(verb: verb)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !searchController.isActive && FeatureToggle.isPaid else { return nil }
        let items = verbsService.groupedItems[section]
        guard let letter = items.first?.infinitive.first else { return nil }
        return letter.uppercased()
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard !searchController.isActive && FeatureToggle.isPaid else { return nil }
        let set = Set(verbsService.items.compactMap { item -> String? in
            guard let character = item.infinitive.first else { return nil }
            return character.uppercased()
        })
        return Array(set).sorted()
    }
}

// MARK: - UITableViewDelegate

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let verb = !searchController.isActive
            ? verbsService.groupedItems[indexPath.section][indexPath.row]
            : verbsService.searchedItems[indexPath.row]
        
        let vc = DetailViewController(verb: verb)
        navigationController?.push(vc, in: splitViewController)
    }
}

// MARK: - UISearchResultsUpdating

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        verbsService.searchText = searchText
        tableView.reloadData()
    }
}
