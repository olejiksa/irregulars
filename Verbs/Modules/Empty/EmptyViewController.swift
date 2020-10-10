//
//  EmptyViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class EmptyViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        guard animated else { return }
        NotificationCenter.default.post(name: Notification.Name.infinitive,
                                        object: nil,
                                        userInfo: ["infinitive": ""])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
