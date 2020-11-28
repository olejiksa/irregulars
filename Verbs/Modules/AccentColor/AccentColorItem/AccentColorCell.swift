//
//  AccentColorCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AccentColorCell: UITableViewCell {

    @IBOutlet private weak var circleView: CircleView!
    @IBOutlet private weak var colorNameLabel: UILabel!
}

// MARK: - CellProtocol

extension AccentColorCell: CellProtocol {
    
    static var identifier: String { "\(AccentColorCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? AccentColorItem else { return }
        
        circleView.color = item.color.color
        colorNameLabel?.text = item.color.rawValue.capitalized.localized
        accessoryType = item.isSelected ? .checkmark : .none
    }
}
