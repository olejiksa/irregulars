//
//  SidebarViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SidebarViewController: UIViewController {
    
    private let presenter: SidebarPresenter
    private var collectionView: UICollectionView?
    
    init(presenter: SidebarPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        setupDataSource()
    }
    
    func select(at selectedIndexPath: IndexPath?) {
        collectionView?.selectItem(at: selectedIndexPath,
                                   animated: true,
                                   scrollPosition: .centeredVertically)
    }
    
    func restore(at indexPath: IndexPath) {
        select(at: indexPath)
        guard let collectionView = collectionView else { return }
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}

// MARK: - Private

private extension SidebarViewController {
    
    func setupNavigationBar() {
        navigationItem.title = Bundle.main.productName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollectionView() {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = presenter
        view.addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout() {
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            configuration.headerMode = .firstItemInSection
            return .list(using: configuration, layoutEnvironment: $1)
        }
    }
    
    func setupDataSource() {
        presenter.setupDataSource(for: collectionView)
    }
}
