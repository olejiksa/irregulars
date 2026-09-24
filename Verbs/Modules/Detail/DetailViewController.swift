//
//  DetailViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class DetailViewController: UIHostingController<DetailView> {
    
    private let viewModel: DetailViewModel
    private let isOpenedByDeeplink: Bool
    private var favoriteButton: UIBarButtonItem?
    private var cancellables = Set<AnyCancellable>()
    
    init(verb: Verb, isOpenedByDeeplink: Bool = false) {
        viewModel = DetailViewModel(verb: verb)
        self.isOpenedByDeeplink = isOpenedByDeeplink
        
        super.init(rootView: DetailView(viewModel: viewModel))
        
        hidesBottomBarWhenPushed = true
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupDelegate()
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController.map { navigationController($0, willShow: self, animated: animated) }
    }
}

// MARK: - Private

private extension DetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = viewModel.title
        navigationItem.largeTitleDisplayMode = .never
        
        let moreButton = UIBarButtonItem(icon: .ellipsis, target: self, action: #selector(didMoreButtonTap))
        favoriteButton = UIBarButtonItem(icon: .star, target: self, action: #selector(didFavoriteTap))
        navigationItem.rightBarButtonItems = [favoriteButton, moreButton].compactMap { $0 }
        
        updateFavoriteButton(isFavorite: viewModel.isFavorite)
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
    
    func subscribe() {
        viewModel.$isFavorite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isFavorite in self?.updateFavoriteButton(isFavorite: isFavorite) }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .favorites)
            .sink { [weak self] _ in self?.viewModel.refreshFavorite() }
            .store(in: &cancellables)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        favoriteButton?.image = isFavorite ? SystemIcon.starFill.image : SystemIcon.star.image
    }
    
    @objc func didFavoriteTap() {
        viewModel.toggleFavorite()
    }
    
    @objc func didMoreButtonTap(_ sender: UIBarButtonItem) {
        presentPlaybackSpeedPopover(from: sender)
    }
}

// MARK: - Restorable

/// `SplitStateManager` branches on this conformance to decide which screens travel
/// between the split view columns. SwiftUI lays itself out again, so there is nothing to restore.
extension DetailViewController: Restorable {
    
    func restore() {}
}

// MARK: - UINavigationControllerDelegate

extension DetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated || isOpenedByDeeplink else { return }
        let title = viewController.navigationItem.title ?? ""
        NotificationCenter.default.post(name: .infinitive,
                                        object: nil,
                                        userInfo: [Notification.Name.infinitive: title])
    }
}
