//
//  PaywallViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PaywallViewController: UIViewController {
    
    private enum Constants {
        static let inset: CGFloat = 20
        static let buttonHeight: CGFloat = 54
    }
    
    var router: PaywallRouter?
    
    private let presenter: PaywallPresenter
    private let purchaseService: PurchaseService
    private let hapticService: HapticService
    
    private var buyButton: BigButton = {
        let button = BigButton()
        button.setTitle("buy_button".localized, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byClipping
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
#if targetEnvironment(macCatalyst)
        button.backgroundColor = UIButton().tintColor
#else
        button.backgroundColor = AccentColor.current.color
#endif
        button.cornerRadius = 10
        button.isPrimary = true
        return button
    }()
    
    private var restoreButton: BigButton = {
        let button = BigButton()
        button.setTitle("restore_purchases".localized, for: .normal)
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byClipping
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
#if targetEnvironment(macCatalyst)
        button.setTitleColor(UIButton().tintColor, for: .normal)
#else
        button.setTitleColor(AccentColor.current.color, for: .normal)
#endif
        button.backgroundColor = .secondarySystemBackground
        button.cornerRadius = 10
        return button
    }()
    
    private var thanksLabel: UILabel = {
        let label = UILabel()
#if targetEnvironment(macCatalyst)
        label.textColor = UIButton().tintColor
#else
        label.textColor = AccentColor.current.color
#endif
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "thank_you".localized
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        return label
    }()
    
    private var footerView: UIStackView = {
        let footerView = UIStackView()
        footerView.axis = .vertical
        footerView.spacing = 10
        return footerView
    }()
    
    private var tableView = FadeTableView(frame: .zero, style: .plain)
    
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
        fetchPrice()
    }
}

// MARK: - Private

private extension PaywallViewController {
    
    func setupNavigationBar() {
        guard let productName = Bundle.main.productName else { return }
            
        navigationItem.title = "\(productName) Pro"
        navigationItem.largeTitleDisplayMode = .never
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didCloseTap))
        navigationItem.rightBarButtonItem = closeButton
    }
    
    func setupTableView() {
        tableView.contentInset = .init(top: 15, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        
        [tableView, footerView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: Constants.inset),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.inset),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.inset),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.inset),
            
            buyButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            restoreButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            thanksLabel.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
        
        tableView.dataSource = presenter.dataSource
        tableView.register(PaywallCell.self)
        
        footerView.addArrangedSubview(buyButton)
        footerView.addArrangedSubview(restoreButton)
        footerView.addArrangedSubview(thanksLabel)
    }
    
    func setupView() {
        thanksLabel.isHidden = !FeatureToggle.isPaid
        buyButton.isHidden = FeatureToggle.isPaid && purchaseService.canMakePayments
        restoreButton.isHidden = FeatureToggle.isPaid
        
        view.backgroundColor = .systemBackground
        
        buyButton.addTarget(self, action: #selector(didBuyTap), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didRestoreTap), for: .touchUpInside)
    }
    
    func fetchPrice() {
        guard !FeatureToggle.isDebug, !FeatureToggle.isPaid else { return }
        purchaseService.fetchPrice(priceHandler: didObtainPrice)
    }
    
    @objc func didBuyTap() {
        guard !FeatureToggle.isDebug else {
            FeatureToggle.isPaid = true
            didCloseTap()
            return
        }
        
        buyButton.showLoading()
        purchaseService.requestProducts(activationHandler: didActivate, errorHandler: didBuy)
    }
    
    @objc func didRestoreTap() {
        guard !FeatureToggle.isDebug else {
            FeatureToggle.isPaid = true
            didCloseTap()
            return
        }
        
        restoreButton.showLoading()
        purchaseService.requestProducts(activationHandler: didActivate, errorHandler: didRestore)
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
