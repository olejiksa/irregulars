//
//  EmptyViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class EmptyViewController: UIViewController {
    
    @IBOutlet private weak var contentLabel: UILabel!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        resetSelectedItem(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentLabel.text = "EmptyViewControllerLabel".localized
    }
}

// MARK: - Private

private extension EmptyViewController {
    
    func resetSelectedItem(_ animated: Bool) {
        
        guard animated else { return }
        NotificationCenter.default.post(name: Notification.Name.infinitive,
                                        object: nil,
                                        userInfo: ["infinitive": ""])
    }
}
