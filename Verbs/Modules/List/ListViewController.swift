//
//  ListViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class ListViewController: UIHostingController<ListView> {
    
    var favoritesOnly: Bool { viewModel.favoritesOnly }
    
    // MARK: Keyboard Shortcuts
    
    override var canBecomeFirstResponder: Bool { true }
    
    override var keyCommands: [UIKeyCommand]? {
        let defaultKeyCommands = super.keyCommands ?? []
        let customKeyCommands: [UIKeyCommand] = [.init(title: "search".localized,
                                                       action: #selector(didSearchPress),
                                                       input: "F",
                                                       modifierFlags: .command,
                                                       discoverabilityTitle: "search".localized),
                                                 .init(title: "print".localized,
                                                       action: #selector(didPrintPress),
                                                       input: "P",
                                                       modifierFlags: .command,
                                                       discoverabilityTitle: "print".localized)]
        
        return defaultKeyCommands + customKeyCommands
    }
    
    // MARK: Private Properties
    
    private let viewModel: ListViewModel
    private let router: ListRouter
    private let searchController = UISearchController(searchResultsController: nil)
    private var listMenu: ListMenu?
    
    private var moreButton: UIBarButtonItem?
    private var editButton: UIBarButtonItem?
    private var doneButton: UIBarButtonItem?
    private var phrasalsButton: UIBarButtonItem?
    
    init(viewModel: ListViewModel, router: ListRouter) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(rootView: ListView(viewModel: viewModel))
        
        viewModel.onSelect = { [weak self] verb in self?.open(verb) }
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMenu()
        setupSearchController()
        selectWhenRegular()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.sizeToFit()
        
        guard animated else { return }
        
        NotificationCenter.default.post(name: .infinitive,
                                        object: nil,
                                        userInfo: [Notification.Name.infinitive: ""])
    }
    
    func search(text: String) {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
        searchController.searchBar.text = text
        viewModel.updateSearch(text: text)
    }
}

// MARK: - Private

private extension ListViewController {
    
    func setupNavigationBar() {
        switch (favoritesOnly, splitViewController?.isCollapsed) {
        case (true, _):
            navigationItem.title = "favorites".localized
        case (false, true):
            navigationItem.title = "verbs".localized
        case (false, _):
            navigationItem.title = "all".localized
        }
        
        moreButton = .init(icon: .ellipsis)
        navigationItem.rightBarButtonItem = moreButton
        
        if favoritesOnly {
            editButton = .init(barButtonSystemItem: .edit, target: self, action: #selector(didEditTap))
            doneButton = .init(barButtonSystemItem: .done, target: self, action: #selector(didEditTap))
            
            navigationItem.leftBarButtonItem = editButton
            
            editButton?.accessibilityIdentifier = AccessibilityIdentifier.editButton.rawValue
            doneButton?.accessibilityIdentifier = AccessibilityIdentifier.doneButton.rawValue
        } else if FeatureToggle.arePhrasalsAvailable {
            phrasalsButton = .init(title: "phrasal_verbs".localized,
                                   image: nil,
                                   target: self,
                                   action: #selector(didPhrasalsTap))
            navigationItem.leftBarButtonItem = phrasalsButton
        }
    }
    
    func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    func setupMenu() {
        let printInfoBlock: Block = { [weak self] in self?.viewModel.print() }
        var updateDerivativesBlock: BoolBlock?
        var updateRegularsBlock: BoolBlock?
        
        if !favoritesOnly {
            updateDerivativesBlock = { [weak self] value in self?.viewModel.updateDerivatives(value) }
            updateRegularsBlock = { [weak self] value in self?.viewModel.updateRegulars(value) }
        }
        
        listMenu = ListMenu(barButtonItem: moreButton,
                            hasTranslation: viewModel.hasTranslation,
                            favoritesOnly: favoritesOnly,
                            printInfoBlock: printInfoBlock,
                            updateDerivativesBlock: updateDerivativesBlock,
                            updateRegularsBlock: updateRegularsBlock)
        listMenu?.build()
    }
    
    /// On a regular width the detail column already shows a verb, so highlight it.
    func selectWhenRegular() {
        guard splitViewController?.isCollapsed == false,
              let title = splitViewController?.secondaryViewController?.topViewController?.navigationItem.title
        else { return }
        
        viewModel.setOpenedVerb(title)
    }
    
    func open(_ verb: Verb) {
        router.goToDetail(with: verb)
        
        guard splitViewController?.isCollapsed != false else { return }
        
        viewModel.selectedVerb = nil
    }
    
    @objc func didEditTap() {
        viewModel.isEditing.toggle()
        navigationItem.leftBarButtonItem = viewModel.isEditing ? doneButton : editButton
    }
    
    @objc func didPhrasalsTap() {
        let nvc = UINavigationController(rootViewController: PhrasalsAssembly().viewController)
        present(nvc, animated: true)
    }
    
    // MARK: Keyboard Shortcuts
    
    @objc func didPrintPress() {
        viewModel.print()
    }
    
    @objc func didSearchPress() {
        searchController.isActive = true
        searchController.searchBar.becomeFirstResponder()
    }
}

// MARK: - UISearchResultsUpdating

extension ListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearch(text: searchController.searchBar.text ?? "")
    }
}

// MARK: - UISearchControllerDelegate

extension ListViewController: UISearchControllerDelegate {
    
    func willPresentSearchController(_ searchController: UISearchController) {
        viewModel.setSearchActive(true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.setSearchActive(false)
        searchController.searchBar.resignFirstResponder()
    }
}

// MARK: - Scrollable

extension ListViewController: Scrollable {
    
    func scrollToTop() {
        viewModel.scrollToTop()
    }
}
