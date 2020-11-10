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
        case verbs, more
    }
    
    private struct RowIdentifier {
        static let all = UUID()
        static let favorites = UUID()
        static let settings = UUID()
    }
    
    weak var viewController: SidebarViewController?
    
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>?
    private var selectedIndexPath: IndexPath? = IndexPath(row: 1, section: 0)
    
    func setupDataSource(for collectionView: UICollectionView?) {
        guard let collectionView = collectionView else { return }
        
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarHeader()
            contentConfiguration.text = item.title
            
            cell.contentConfiguration = contentConfiguration
            cell.tintColor = .systemBlue
        }
        
        let expandableRowRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = [.outlineDisclosure()]
            cell.tintColor = .systemBlue
        }
        
        let rowRegistration = UICollectionView.CellRegistration<SidebarCell, SidebarItem> {
            (cell, indexPath, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarSubtitleCell()
            contentConfiguration.text = item.title
            contentConfiguration.secondaryText = item.subtitle
            contentConfiguration.image = item.image
            
            cell.contentConfiguration = contentConfiguration
            cell.tintColor = .systemBlue
        }
        
        dataSource = .init(collectionView: collectionView) {
            switch $2.type {
            case .header:
                return $0.dequeueConfiguredReusableCell(using: headerRegistration, for: $1, item: $2)
            case .expandableRow:
                return $0.dequeueConfiguredReusableCell(using: expandableRowRegistration, for: $1, item: $2)
            default:
                return $0.dequeueConfiguredReusableCell(using: rowRegistration, for: $1, item: $2)
            }
        }
        
        applyInitialSnapshot()
    }
}

// MARK: - Private

private extension SidebarPresenter {
    
    func verbsSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Verbs".localized)
        
        let items: [SidebarItem] = [
            .row(title: "All".localized,
                 subtitle: nil,
                 image: SystemIcon.book.image,
                 id: RowIdentifier.all),
            .row(title: "Favorites".localized,
                 subtitle: nil,
                 image: SystemIcon.star.image,
                 id: RowIdentifier.favorites)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    func moreSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "More".localized)
        
        let items: [SidebarItem] = [
            .row(title: "Settings".localized,
                 subtitle: nil,
                 image: SystemIcon.gear.image,
                 id: RowIdentifier.settings)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    func applyInitialSnapshot() {
        dataSource?.apply(verbsSnapshot(), to: .verbs, animatingDifferences: false)
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
        case RowIdentifier.settings:
            let vc = SettingsAssembly().viewController()
            vc.navigationController?.modalPresentationStyle = .formSheet
            vc.navigationController.map { splitViewController.present($0, animated: true) }
            viewController?.select(at: selectedIndexPath)
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SidebarPresenter: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let sidebarItem = dataSource?.itemIdentifier(for: indexPath),
            indexPath != selectedIndexPath
        else { return }
        
        switch indexPath.section {
        case SidebarSection.verbs.rawValue, SidebarSection.more.rawValue:
            didSelectLibraryItem(sidebarItem, at: indexPath)
        default:
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}
