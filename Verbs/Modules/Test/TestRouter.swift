//
//  TestRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 22.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
        
        RateService().requestReviewIfAppropriate(minimumReviewWorthyActionCount: 8)
    }
    
    func show(hint: String) {
        let alertController = UIAlertController(title: "hint".localized,
                                                message: hint,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "ok".localized, style: .default))
        viewController?.present(alertController, animated: true)
    }
}

