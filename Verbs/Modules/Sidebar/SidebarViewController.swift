//
//  SidebarViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SidebarViewController: UIViewController {
    
    private enum SidebarItemType: Int {
        case header, row, expandableRow
    }
    
    private enum SidebarSection: Int {
        case library, tests, collections
    }
    
    private struct SidebarItem: Hashable, Swift.Identifiable {
        let id: UUID
        let type: SidebarItemType
        let title: String
        let subtitle: String?
        let image: UIImage?
        
        static func header(title: String, id: UUID = UUID()) -> Self {
            .init(id: id, type: .header, title: title, subtitle: nil, image: nil)
        }
        
        static func expandableRow(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            .init(id: id, type: .expandableRow, title: title, subtitle: subtitle, image: image)
        }
        
        static func row(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
            .init(id: id, type: .row, title: title, subtitle: subtitle, image: image)
        }
    }
    
    private struct RowIdentifier {
        static let all = UUID()
        static let favorites = UUID()
        static let settings = UUID()
        static let about = UUID()
        static let upgrade = UUID()
        static let forms = UUID()
        static let letters = UUID()
        static let pronunciation = UUID()
        static let sentences = UUID()
        static let statistics = UUID()
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupCollectionView()
        setupDataSource()
        applyInitialSnapshot()
        collectionView.selectItem(at: IndexPath(row: 1, section: 0),
                                  animated: false,
                                  scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
    }
}

// MARK: - Private

private extension SidebarViewController {
    
    func setupNavigationBar() {
        navigationItem.title = Bundle.main.productName
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func setupDataSource() {
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
        
        dataSource = UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell in
            switch item.type {
            case .header:
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            case .expandableRow:
                return collectionView.dequeueConfiguredReusableCell(using: expandableRowRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: rowRegistration,
                                                                    for: indexPath,
                                                                    item: item)
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout() { _, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
            configuration.showsSeparators = false
            configuration.headerMode = .firstItemInSection
            return .list(using: configuration, layoutEnvironment: layoutEnvironment)
        }
    }
    
    private func librarySnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Verbs".localized)
        
        let items: [SidebarItem] = [
            .row(title: "All".localized, subtitle: nil, image: SystemIcon.book.image, id: RowIdentifier.all),
            .row(title: "Favorites".localized, subtitle: nil, image: SystemIcon.star.image, id: RowIdentifier.favorites)
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    private func testsSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "Tests".localized)
        
        let items: [SidebarItem] = [
            .row(title: "Three forms".localized, subtitle: nil, image: SystemIcon.forms.image, id: RowIdentifier.forms),
            .row(title: "Letters".localized, subtitle: nil, image: SystemIcon.letters.image, id: RowIdentifier.letters),
            .row(title: "Sentences".localized, subtitle: nil, image: SystemIcon.sentences.image, id: RowIdentifier.sentences),
            .row(title: "Pronunciation".localized, subtitle: nil, image: SystemIcon.pronunciation.image, id: RowIdentifier.pronunciation),
        ]
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    private func collectionsSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem.header(title: "More".localized)
        
        var items: [SidebarItem] = [
//            .row(title: "Statistics".localized, subtitle: nil, image: SystemIcon.chart.image, id: RowIdentifier.statistics),
            .row(title: "Settings".localized, subtitle: nil, image: SystemIcon.gear.image, id: RowIdentifier.settings)
//            .row(title: "About".localized, subtitle: nil, image: SystemIcon.info.image, id: RowIdentifier.about)
        ]
        
        if !FeatureToggle.isPaid {
            items.append(.row(title: "Upgrade to Pro".localized, subtitle: nil, image: SystemIcon.upgrade.image, id: RowIdentifier.upgrade))
        }
        
        snapshot.append([header])
        snapshot.expand([header])
        snapshot.append(items, to: header)
        return snapshot
    }
    
    func applyInitialSnapshot() {
        dataSource.apply(librarySnapshot(), to: .library, animatingDifferences: false)
        // dataSource.apply(testsSnapshot(), to: .tests, animatingDifferences: false)
        dataSource.apply(collectionsSnapshot(), to: .collections, animatingDifferences: false)
    }
    
    private func didSelectLibraryItem(_ sidebarItem: SidebarItem, at indexPath: IndexPath) {
        guard let splitViewController = splitViewController else { return }
        
        switch sidebarItem.id {
        case RowIdentifier.all:
            let vc = ListAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
        case RowIdentifier.favorites:
            let vc = ListAssembly(splitViewController: splitViewController).viewController()
            splitViewController.setViewController(vc.navigationController, for: .supplementary)
        case RowIdentifier.settings:
            let vc = SettingsAssembly().viewController()
            vc.navigationController?.modalPresentationStyle = .formSheet
            vc.navigationController.map { splitViewController.present($0, animated: true) }
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SidebarViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sidebarItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch indexPath.section {
        case SidebarSection.library.rawValue:
            didSelectLibraryItem(sidebarItem, at: indexPath)
        case SidebarSection.tests.rawValue:
            didSelectLibraryItem(sidebarItem, at: indexPath)
            collectionView.deselectItem(at: indexPath, animated: true)
        default:
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}
