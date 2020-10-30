//
//  PlainCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PlainCell: UITableViewCell {}

// MARK: - CellProtocol

extension PlainCell: CellProtocol {
    
    static var identifier: String { "\(PlainCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? PlainItem else { return }
        
        textLabel?.text = item.title
        accessoryType = item.hasDisclosureIndicator ? .disclosureIndicator : .none
    }
}
