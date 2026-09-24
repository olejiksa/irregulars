//
//  TestViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

final class TestViewController: UIHostingController<TestSessionView> {
    
    private let viewModel: TestSessionViewModel
    
    init(viewModel: TestSessionViewModel, title: String) {
        self.viewModel = viewModel
        
        super.init(rootView: TestSessionView(viewModel: viewModel))
        
        self.title = title
        hidesBottomBarWhenPushed = true
        
        viewModel.onFinish = { [weak self] in self?.goBack() }
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.checkAvailability()
    }
}

// MARK: - Private

private extension TestViewController {
    
    func setupNavigationBar() {
        navigationItem.title = title
        navigationItem.largeTitleDisplayMode = .never
        
        let shouldMoreButtonBeShown = [Test.listening, Test.speaking].contains(viewModel.test)
        let moreButton = shouldMoreButtonBeShown ?
            UIBarButtonItem(icon: .ellipsis, target: self, action: #selector(didMoreButtonTap)) :
            nil
        
        let skipButton = UIBarButtonItem(icon: .skip, target: self, action: #selector(didSkipButtonTap))
        skipButton.accessibilityLabel = "skip".localized
        
        navigationItem.rightBarButtonItems = [skipButton, moreButton].compactMap { $0 }
    }
    
    func goBack() {
        navigationController?.popViewController(animated: true)
        
        RateService().requestReviewIfAppropriate(minimumReviewWorthyActionCount: 5)
    }
    
    @objc func didMoreButtonTap(_ sender: UIBarButtonItem) {
        presentPlaybackSpeedPopover(from: sender)
    }
    
    @objc func didSkipButtonTap() {
        viewModel.skip()
    }
}

// MARK: - Restorable

/// `SplitStateManager` branches on this conformance to decide which screens travel
/// between the split view columns. SwiftUI lays itself out again, so there is nothing to restore.
extension TestViewController: Restorable {
    
    func restore() {}
}

// MARK: - UINavigationControllerDelegate

extension TestViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated else { return }
        
        if viewController is EmptyViewController {
            NotificationCenter.default.post(name: .test, object: nil, userInfo: [:])
        }
    }
}
