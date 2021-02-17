//
//  IconDetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class IconDetailCell: UITableViewCell {
    
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

extension IconDetailCell: CellProtocol {
    
    static var identifier: String { "\(IconDetailCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? IconDetailItem else { return }
        
        iconView.image = item.icon.image
        iconView.accessibilityLabel = item.iconAccessibilityText
        
        titleLabel?.text = item.text
    }
}
