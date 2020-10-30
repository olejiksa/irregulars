//
//  PaywallCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PaywallCell: UITableViewCell {
    
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var iconView: UIImageView!
}

// MARK: - CellProtocol

extension PaywallCell: CellProtocol {
    
    static var identifier: String { "\(PaywallCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? PaywallItem else { return }
        
        iconView.image = UIImage(systemName: item.icon.rawValue)
        contentLabel?.text = item.text
    }
}
