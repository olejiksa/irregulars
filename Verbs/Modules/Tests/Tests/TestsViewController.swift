//
//  TestsViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class TestsViewController: UIHostingController<TestsView> {
    
    private let viewModel: TestsViewModel
    private let router: TestsRouter
    private var moreButton: UIBarButtonItem?
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: TestsViewModel, router: TestsRouter) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(rootView: TestsView(viewModel: viewModel))
        
        viewModel.onSelect = { [weak self] test in self?.open(test) }
        viewModel.onEmptyFavorites = { [weak self] in self?.router.showEmptyFavorites() }
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .test,
                                        object: nil,
                                        userInfo: [:])
    }
}

// MARK: - Scrollable

extension TestsViewController: Scrollable {
    
    func scrollToTop() {
        viewModel.scrollToTop()
    }
}

// MARK: - Private

private extension TestsViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "tests".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        
        moreButton = .init(icon: .filter)
        buildMenu(for: moreButton)
        navigationItem.rightBarButtonItem = moreButton
    }
    
    func setupMoreButtonIcon() {
        let isFiltered = UserDefaults.shared.bool(for: .favoritesOnly) ||
            !UserDefaults.shared.bool(for: .regularVerbsTests) ||
            !UserDefaults.shared.bool(for: .derivativesTests)
        moreButton?.image = !isFiltered
            ? SystemIcon.filter.image
            : SystemIcon.unfilter.image
    }
    
    /// The purchase can unlock menu options, so the menu is rebuilt when it lands.
    func subscribe() {
        NotificationCenter.default.publisher(for: .reload)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.buildMenu(for: self?.moreButton) }
            .store(in: &cancellables)
    }
    
    func open(_ test: Test?) {
        guard let test = test else {
            router.goToStatistics()
            return
        }
        
        router.goTo(test: test)
    }
    
    func buildMenu(for barButtonItem: UIBarButtonItem?) {
        setupMoreButtonIcon()
        
        let isPaid = FeatureToggle.isPaid
        let favoritesOnly = UserDefaults.shared.bool(for: .favoritesOnly)
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
        
        let allMenu = isPaid && !favoritesOnly ?
            [UIMenu(options: .displayInline, children: [
                UIAction(title: .localized(.regularVerbs),
                         state: shouldRegularVerbsBeShown ? .on : .off,
                         handler: handleRegularsMenu)
            ]),
            UIMenu(options: .displayInline, children: [
                UIAction(title: .localized(.derivatives),
                         state: shouldDerivativesBeShown ? .on : .off,
                         handler: handleDerivativesMenu)
            ])] : []
        
        barButtonItem?.menu = .init(children: [
            UIMenu(options: .displayInline, children: [
                UIAction(title: .localized(.demo),
                         image: SystemIcon.twentyFive.image,
                         attributes: !isPaid ? [] : .hidden,
                         state: !isPaid ? .on : .off,
                         handler: handleMenu),
                UIAction(title: "all".localized,
                         image: SystemIcon.listBullet.image,
                         state: isPaid && !favoritesOnly ? .on : .off,
                         handler: handleMenu),
                UIAction(title: "favorites".localized,
                         image: SystemIcon.star.image,
                         state: isPaid && favoritesOnly ? .on : .off,
                         handler: handleMenu)
            ])
        ] + allMenu)
    }
    
    func handleMenu(action: UIAction) {
        let isPaid = FeatureToggle.isPaid
        
        if isPaid {
            let favoritesOnly = UserDefaults.shared.bool(for: .favoritesOnly)
            let state = action.state == .on
            let newState = favoritesOnly == state
            UserDefaults.shared.set(newState, for: .favoritesOnly)
        } else if action.state == .off {
            router.goToPaywall()
        } else {
            return
        }
        
        buildMenu(for: moreButton)
    }
    
    func handleRegularsMenu(action: UIAction) {
        guard FeatureToggle.isPaid else {
            router.goToPaywall()
            return
        }
        
        let shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        UserDefaults.shared.set(!shouldRegularVerbsBeShown, for: .regularVerbsTests)
        buildMenu(for: moreButton)
    }
    
    func handleDerivativesMenu(action: UIAction) {
        guard FeatureToggle.isPaid else {
            router.goToPaywall()
            return
        }
        
        let shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
        UserDefaults.shared.set(!shouldDerivativesBeShown, for: .derivativesTests)
        buildMenu(for: moreButton)
    }
}
