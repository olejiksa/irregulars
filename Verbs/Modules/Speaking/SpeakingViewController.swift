//
//  SpeakingViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 31.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SpeakingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
    }
}

// MARK: - Private

private extension SpeakingViewController {
    
    func setupNavigationBar() {
        navigationItem.title = .localized(.speaking)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupView() {
        view.backgroundColor = .systemGroupedBackground
    }
}
