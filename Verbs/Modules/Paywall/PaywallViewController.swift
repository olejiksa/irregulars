//
//  PaywallViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PaywallViewController: UIViewController {
    
    private let dataSource = SectionDataSource()
    private let userDefaultsService = UserDefaultsService()

    @IBOutlet private weak var thanksLabel: UILabel!
    @IBOutlet private weak var buyButton: BigButton!
    @IBOutlet private weak var restoreButton: BigButton!
    @IBOutlet private weak var tableView: FadeTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupView()
        setupSections()
    }
}

// MARK: - Private

private extension PaywallViewController {
    
    func setupNavigationBar() {
        guard let productName = Bundle.main.productName else { return }
            
        navigationItem.title = "\(productName) Pro".localized
        navigationItem.largeTitleDisplayMode = .never
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(didCloseTap))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupTableView() {
        tableView.contentInset = .init(top: 15, left: 0, bottom: 10, right: 0)
        tableView.dataSource = dataSource
        tableView.register(PaywallCell.self)
    }
    
    func setupView() {
        buyButton.setTitle("Buy".localized, for: .normal)
        restoreButton.setTitle("Restore purchases".localized, for: .normal)
        thanksLabel.text = "Thank you".localized
        thanksLabel.isHidden = !FeatureToggle.isPaid
        buyButton.isHidden = FeatureToggle.isPaid
        restoreButton.isHidden = FeatureToggle.isPaid
    }
    
    func setupSections() {
        let item = LanguageService().hasTranslation ?  PaywallItem(text: "View a translation without going to the verb page".localized, icon: .dictionary) : nil
        
        dataSource.setup([Section(header: nil,
                                  items: [
                                    PaywallItem(text: "Listen to pronunciation".localized,
                                                icon: .speaker),
                                    PaywallItem(text: "See a transcription".localized,
                                                icon: .transcription),
                                    PaywallItem(text: "Add unlimited items in Favorites".localized,
                                                icon: .listStar),
                                    PaywallItem(text: "Find words faster using search".localized,
                                                icon: .search),
                                    PaywallItem(text: "Find words faster using the alphabetical scrollbar".localized,
                                                icon: .alphabet),
//                                    PaywallItem(text: "Use the medium-sized widget that has all three verb's forms, their transcriptions, and its translation".localized,
//                                                icon: .widget),
                                    PaywallItem(text: "Hide or show regular verbs (-ed)".localized,
                                                icon: .toggle),
                                    PaywallItem(text: "Hide or show derivatives".localized,
                                                icon: .toggle),
                                    item
                                  ].compactMap { $0 })])
    }
    
    @IBAction func didUnlockTap() {
        unlockAllFeatures()
    }
    
    @IBAction func didRestoreTap() {
        unlockAllFeatures()
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
    
    func unlockAllFeatures() {
        FeatureToggle.isPaid = true
        userDefaultsService.save(true, by: .isPaid)
        view.window?.rootViewController?.dismiss(animated: true)
        NotificationCenter.default.post(name: .paid, object: nil)
    }
}
