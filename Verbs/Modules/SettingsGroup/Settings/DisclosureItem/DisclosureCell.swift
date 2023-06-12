//
//  DisclosureCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DisclosureCell: UITableViewCell {}

// MARK: - CellProtocol

extension DisclosureCell: CellProtocol {
    
    static var identifier: String { "\(DisclosureCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? DisclosureItem else { return }
        
        textLabel?.text = item.text
        
        isUserInteractionEnabled = item.isEnabled
        textLabel?.isEnabled = item.isEnabled
    }
}
