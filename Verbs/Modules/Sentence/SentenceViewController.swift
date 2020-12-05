//
//  SentenceViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 06.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SentenceViewController: UIViewController {
    
    private let presenter: SentencePresenter

    init(presenter: SentencePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
}

// MARK: - Private

private extension SentenceViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "SentenceTitle".localized
        navigationItem.largeTitleDisplayMode = .never
        
        let hintItem = UIBarButtonItem(image: SystemIcon.question.image,
                                       style: .plain,
                                       target: presenter,
                                       action: #selector(presenter.showHint))
        navigationItem.rightBarButtonItem = hintItem
    }
}
