//
//  PaywallViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PaywallViewController: UIViewController {
    
    var router: PaywallRouter?
    
    private let presenter: PaywallPresenter
    private let purchaseService: PurchaseService

    @IBOutlet private weak var thanksLabel: UILabel!
    @IBOutlet private weak var buyButton: BigButton!
    @IBOutlet private weak var restoreButton: BigButton!
    @IBOutlet private weak var tableView: FadeTableView!
    
    init(presenter: PaywallPresenter,
         purchaseService: PurchaseService) {
        self.presenter = presenter
        self.purchaseService = purchaseService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupView()
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
        tableView.dataSource = presenter.dataSource
        tableView.register(PaywallCell.self)
    }
    
    func setupView() {
        buyButton.setTitle("Buy".localized, for: .normal)
        restoreButton.setTitle("Restore purchases".localized, for: .normal)
        thanksLabel.text = "Thank you".localized
        thanksLabel.isHidden = !FeatureToggle.isPaid
        buyButton.isHidden = FeatureToggle.isPaid && purchaseService.canMakePayments
        restoreButton.isHidden = FeatureToggle.isPaid
    }
    
    @IBAction func didBuyTap() {
        buyButton.showLoading()
        purchaseService.requestProducts(activationHandler: didActivate,
                                        errorHandler: didBuy)
    }
    
    @IBAction func didRestoreTap() {
        restoreButton.showLoading()
        purchaseService.requestProducts(activationHandler: didActivate,
                                        errorHandler: didRestore)
    }
    
    @objc func didCloseTap() {
        dismiss(animated: true)
    }
    
    func didActivate() {
        DispatchQueue.main.async {
            self.buyButton.hideLoading()
            self.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    func didBuy(error: Error?) {
        DispatchQueue.main.async {
            if (error as? PurchaseError) != nil {
                self.buyButton.hideLoading()
            } else if let error = error {
                self.router?.show(error: error)
                self.buyButton.hideLoading()
            } else {
                self.purchaseService.buy()
            }
        }
    }
    
    func didRestore(error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                self.router?.show(error: error)
                self.restoreButton.hideLoading()
            } else {
                self.purchaseService.restorePurchases()
            }
        }
    }
}
