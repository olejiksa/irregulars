//
//  BarButtonItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 14.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(icon: SystemIcon) {
        self.init(image: icon.image, style: .plain, target: nil, action: nil)
    }
    
    convenience init(barButtonSystemItem systemItem: SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
}
