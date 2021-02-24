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
    private let hapticService: HapticService

    @IBOutlet private weak var thanksLabel: UILabel!
    @IBOutlet private weak var buyButton: BigButton!
    @IBOutlet private weak var restoreButton: BigButton!
    @IBOutlet private weak var tableView: FadeTableView!
    
    init(presenter: PaywallPresenter,
         purchaseService: PurchaseService,
         hapticService: HapticService) {
        self.presenter = presenter
        self.purchaseService = purchaseService
        self.hapticService = hapticService
        
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
        
        purchaseService.fetchPrice(priceHandler: didObtainPrice)
    }
}

// MARK: - Private

private extension PaywallViewController {
    
    func setupNavigationBar() {
        guard let productName = Bundle.main.productName else { return }
            
        navigationItem.title = "\(productName) Pro"
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
        buyButton.setTitle("buy_button".localized, for: .normal)
        #if !targetEnvironment(macCatalyst)
        thanksLabel.textColor = AccentColor.current.color
        buyButton.backgroundColor = AccentColor.current.color
        #else
        let button = UIButton()
        thanksLabel.textColor = button.tintColor
        buyButton.backgroundColor = button.tintColor
        #endif
        buyButton.titleLabel?.numberOfLines = 1
        buyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        buyButton.titleLabel?.lineBreakMode = .byClipping
        
        restoreButton.setTitle("restore_purchases".localized, for: .normal)
        #if !targetEnvironment(macCatalyst)
        restoreButton.setTitleColor(AccentColor.current.color, for: .normal)
        #else
        restoreButton.setTitleColor(UIButton().tintColor, for: .normal)
        #endif
        restoreButton.titleLabel?.numberOfLines = 1
        restoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        restoreButton.titleLabel?.lineBreakMode = .byClipping
        
        thanksLabel.text = "thank_you".localized
        
        #if !targetEnvironment(macCatalyst)
        thanksLabel.textColor = AccentColor.current.color
        #else
        thanksLabel.textColor = UIButton().tintColor
        #endif
        
        thanksLabel.isHidden = !FeatureToggle.isPaid
        buyButton.isHidden = FeatureToggle.isPaid && purchaseService.canMakePayments
        restoreButton.isHidden = FeatureToggle.isPaid
    }
    
    @IBAction func didBuyTap() {
        guard !FeatureToggle.isDebug else {
            FeatureToggle.isPaid = true
            didCloseTap()
            return
        }
        
        buyButton.showLoading()
        purchaseService.requestProducts(activationHandler: didActivate,
                                        errorHandler: didBuy)
    }
    
    @IBAction func didRestoreTap() {
        guard !FeatureToggle.isDebug else {
            FeatureToggle.isPaid = true
            didCloseTap()
            return
        }
        
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
            self.restoreButton.hideLoading()
            self.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    func didObtainPrice(_ price: String) {
        DispatchQueue.main.async {
            self.buyButton.setTitle("\("buy_for".localized) \(price)", for: .normal)
        }
    }
    
    func didBuy(error: Error?) {
        DispatchQueue.main.async {
            if (error as? PurchaseError) != nil {
                self.buyButton.hideLoading()
            } else if let error = error {
                self.hapticService.generateHapticFeedback(for: .notification(.error))
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
                self.hapticService.generateHapticFeedback(for: .notification(.error))
                self.router?.show(error: error)
                self.restoreButton.hideLoading()
            } else {
                self.purchaseService.restorePurchases()
            }
        }
    }
}
