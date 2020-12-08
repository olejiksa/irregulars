//
//  PlainDetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PlainDetailCell: UITableViewCell {
        
    @IBOutlet private weak var titleLabel: UILabel!
}

// MARK: - CellProtocol

extension PlainDetailCell: CellProtocol {
    
    static var identifier: String { "\(PlainDetailCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? PlainDetailItem else { return }
        
        titleLabel.text = item.text
    }
}
