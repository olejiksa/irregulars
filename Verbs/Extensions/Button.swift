//
//  Button.swift
//  Verbs
//
//  Created by Oleg Samoylov on 01.04.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UIButton {
    
    func set(icon systemIcon: SystemIcon) {
        setImage(systemIcon.image, for: .normal)
    }
}
