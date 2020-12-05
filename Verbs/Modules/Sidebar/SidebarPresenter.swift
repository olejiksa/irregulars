//
//  SidebarPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

final class SidebarPresenter: NSObject {
    
    private enum SidebarSection: Int {
        case verbs, tests, more
    }
    
    private struct RowIdentifier {
        static let all = UUID()
        static let favorites = UUID()
        static let tests = UUID()
        static let settings = UUID()
    }
    
    weak var viewController: SidebarViewController?
    
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>?
    private var selectedIndexPath: IndexPath? = IndexPath(row: 1, section: 0)
    
    override init() {
        super.init()
        subscribe()
    }
    
    func setupDataSource(for collectionView: UICollectionView?) {
        guard let collectionView = collectionView else { return }
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarHeader()
            contentConfiguration.text = item.title
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = item.isExpandable ? [.outlineDisclosure()] : []
            cell.tintColor = AccentColor.current.color
        }
        
        let rowRegistration = UICollectionView.CellRegistration<SidebarCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = item.isExpandable ? [.outlineDisclosure()] : []
            cell.tintColor = AccentColor.current.color
        }
        
        dataSource = .init(collectionView: collectionView) {
            switch $2.type {
            case .header:
                return $0.dequeueConfiguredReusableCell(using: headerRegistration, for: $1, item: $2)
            default:
                return $0.dequeueConfiguredReusableCell(using: rowRegistration, for: $1, item: $2)
            }
        }
        
        applyInitialSnapshot()
    }
}

// MARK: - Private

private extension SidebarPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    func verbsSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Verbs".localized)
        
        let items: [SidebarItem] = [
            .row(title: "All".localized,
                 image: SystemIcon.book.image,
                 id: RowIdentifier.all),
            .row(title: "Favorites".localized,
                 image: SystemIcon.star.image,
                 id: RowIdentifier.favorites),
            .row(title: "Tests".localized,
                 subtitle: nil,
                 image: SystemIcon.puzzle.image,
                 id: RowIdentifier.tests)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    func testsSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Tests".localized, isExpandable: true)
        
        let items: [SidebarItem] = [
            .row(title: "Test 1".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 2".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 3".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 4".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 5".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 6".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 7".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests),
            .row(title: "Test 8".localized,
                 image: SystemIcon.folder.image,
                 id: RowIdentifier.tests)
        ]
        
        snapshot.append([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    func moreSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "More".localized)
        
        let items: [SidebarItem] = [
            .row(title: "Settings".localized,
                 image: SystemIcon.gear.image,
                 id: RowIdentifier.settings)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items)
        return snapshot
    }
    
    func applyInitialSnapshot() {
        dataSource?.apply(verbsSnapshot(), to: .verbs, animatingDifferences: false)
        // dataSource?.apply(testsSnapshot(), to: .tests, animatingDifferences: false)
        dataSource?.apply(moreSnapshot(), to: .more, animatingDifferences: false)
        
        viewController?.select(at: selectedIndexPath)
    }
    
    func didSelectLibraryItem(_ sidebarItem: SidebarItem, at indexPath: IndexPath) {
        guard let splitViewController = viewController?.splitViewController else { return }
        
        guard sidebarItem.type == .row else {
            viewController?.select(at: selectedIndexPath)
            return
        }
        
        switch sidebarItem.id {
        case RowIdentifier.all:
            selectedIndexPath = indexPath
            let vc = ListAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
        case RowIdentifier.favorites:
            selectedIndexPath = indexPath
            let vc = FavoritesAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
        case RowIdentifier.tests:
            selectedIndexPath = indexPath
            let vc = TestsAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
        case RowIdentifier.settings:
            viewController?.select(at: selectedIndexPath)
            let nvc = splitViewController.secondaryViewController
            let vc = SettingsAssembly(navigationController: nvc).viewController()
            guard !(nvc?.topViewController is SettingsViewController) else { return }
            nvc?.popToRootViewController(animated: false)
            nvc?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    @objc func didPay() {
        viewController?.getPaid()
        viewController?.select(at: selectedIndexPath)
    }
}

// MARK: - UICollectionViewDelegate

extension SidebarPresenter: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let sidebarItem = dataSource?.itemIdentifier(for: indexPath),
            indexPath != selectedIndexPath
        else {
            viewController?.select(at: selectedIndexPath)
            return
        }
        
        switch indexPath.section {
        case SidebarSection.verbs.rawValue, SidebarSection.tests.rawValue, SidebarSection.more.rawValue:
            didSelectLibraryItem(sidebarItem, at: indexPath)
        default:
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}
