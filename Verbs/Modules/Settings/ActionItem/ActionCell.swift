//
//  ActionCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ActionCell: UITableViewCell {}

// MARK: - CellProtocol

extension ActionCell: CellProtocol {
    
    static var identifier: String { "\(ActionCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? ActionItem else { return }
        
        textLabel?.text = item.text
        
        switch item.style {
        case .standard:
            textLabel?.textColor = AccentColor.current.color
        case .destructive:
            textLabel?.textColor = .systemRed
        }
    }
}
