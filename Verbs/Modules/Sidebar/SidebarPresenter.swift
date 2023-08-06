//
//  SidebarPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

final class SidebarPresenter: NSObject {
    
    private enum SidebarSection: Int {
        case verbs, more
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
            (cell, _, item) in
            
            var contentConfiguration = UIListContentConfiguration.sidebarHeader()
            contentConfiguration.text = item.title
            
            cell.contentConfiguration = contentConfiguration
            cell.accessories = item.isExpandable ? [.outlineDisclosure()] : []
            
            cell.accessibilityIdentifier = item.accessibilityIdentifier?.rawValue
        }
        
        let rowRegistration = UICollectionView.CellRegistration<SidebarCell, SidebarItem> {
            (cell, _, item) in
            
            cell.item = item
            cell.accessories = item.isExpandable ? [.outlineDisclosure()] : []
            
            cell.accessibilityIdentifier = item.accessibilityIdentifier?.rawValue
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
                                               name: .reload,
                                               object: nil)
    }
    
    func verbsSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "verbs".localized)
        
        let items: [SidebarItem] = [
            .row(title: "all".localized,
                 image: SystemIcon.book.image,
                 id: RowIdentifier.all,
                 accessibilityIdentifier: .verbsTab),
            .row(title: "favorites".localized,
                 image: SystemIcon.star.image,
                 id: RowIdentifier.favorites,
                 accessibilityIdentifier: .favoritesTab),
            .row(title: "tests".localized,
                 subtitle: nil,
                 image: SystemIcon.puzzle.image,
                 id: RowIdentifier.tests,
                 accessibilityIdentifier: .testsTab)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    func moreSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "more".localized)
        
        let items: [SidebarItem] = [
            .row(title: "settings".localized,
                 image: SystemIcon.gear.image,
                 id: RowIdentifier.settings,
                 accessibilityIdentifier: .settingsTab)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items)
        return snapshot
    }
    
    func applyInitialSnapshot() {
        dataSource?.apply(verbsSnapshot(), to: .verbs, animatingDifferences: false)
#if !targetEnvironment(macCatalyst)
        dataSource?.apply(moreSnapshot(), to: .more, animatingDifferences: false)
#endif
        
        viewController?.select(at: selectedIndexPath)
    }
    
    func didSelectLibraryItem(_ sidebarItem: SidebarItem, at indexPath: IndexPath) {
        guard let splitViewController = viewController?.splitViewController else { return }
        
        guard sidebarItem.type == .row else {
            viewController?.select(at: selectedIndexPath)
            return
        }
        
        switch sidebarItem.id {
        case RowIdentifier.all, RowIdentifier.favorites:
            selectedIndexPath = indexPath
            let favoritesOnly = sidebarItem.id == RowIdentifier.favorites
            let vc = ListAssembly(splitViewController: splitViewController, favoritesOnly: favoritesOnly).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
            NotificationCenter.default.post(name: .sidebar,
                                            object: nil,
                                            userInfo: [Notification.Name.sidebar: true])
            let nvc = splitViewController.secondaryViewController
            guard nvc?.topViewController is TestViewController else { return }
            nvc?.popToRootViewController(animated: true)
        case RowIdentifier.tests:
            selectedIndexPath = indexPath
            let vc = TestsAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
            
            NotificationCenter.default.post(name: .sidebar,
                                            object: nil,
                                            userInfo: [Notification.Name.sidebar: false])
        case RowIdentifier.settings:
            viewController?.select(at: selectedIndexPath)
            let vc = CustonHostingController(shouldShowNavigationBar: false, rootView: SettingsView())
            splitViewController.setViewController(vc, for: .secondary)
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
        case SidebarSection.verbs.rawValue, SidebarSection.more.rawValue:
            didSelectLibraryItem(sidebarItem, at: indexPath)
        default:
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

// MARK: - UICollectionViewDropDelegate

extension SidebarPresenter: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.items {
            guard let verb = item.dragItem.localObject as? Verb else { continue }
            Locator.favorites.add(verb)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: VerbDragItem.self)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let destinationIndexPath = destinationIndexPath,
              let sidebarItem = dataSource?.itemIdentifier(for: destinationIndexPath),
              destinationIndexPath.section == SidebarSection.verbs.rawValue,
              sidebarItem.id == RowIdentifier.favorites else { return .init(operation: .forbidden) }
        return .init(operation: .copy, intent: .insertIntoDestinationIndexPath)
    }
}

final class CustonHostingController<Content>: UIHostingController<AnyView> where Content : View {
    
    public init(shouldShowNavigationBar: Bool, rootView: Content) {
        super.init(rootView: AnyView(rootView.navigationBarHidden(!shouldShowNavigationBar)))
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
