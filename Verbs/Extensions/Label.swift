//
//  Label.swift
//  Verbs
//
//  Created by Oleg Samoylov on 27.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UILabel {
    
    static var noDataLabel: UILabel {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }
}
