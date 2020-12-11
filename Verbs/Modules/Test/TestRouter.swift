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
    }
    
    func show(hint: String) {
        let alertController = UIAlertController(title: "Hint".localized,
                                                message: hint,
                                                preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        viewController?.present(alertController, animated: true)
    }
}

