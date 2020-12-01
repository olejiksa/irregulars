//
//  RightDetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RightDetailCell: UITableViewCell {}

// MARK: - CellProtocol

extension RightDetailCell: CellProtocol {
    
    static var identifier: String { "\(RightDetailCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? RightDetailItem else { return }
        
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
        accessoryType = item.hasDisclosureItem ? .disclosureIndicator : .none
        
        isUserInteractionEnabled = item.isEnabled
        textLabel?.isEnabled = item.isEnabled || !item.hasDisclosureItem
        detailTextLabel?.isEnabled = item.isEnabled || !item.hasDisclosureItem
    }
}
