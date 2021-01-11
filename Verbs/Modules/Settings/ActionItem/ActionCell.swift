//
//  ActionCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ActionCell: UITableViewCell {
    
    private var style: ActionItem.Style = .standard {
        didSet {
            applyStyle()
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        applyStyle()
    }
}

// MARK: - Private

private extension ActionCell {
    
    func applyStyle() {
        switch (style, tintAdjustmentMode, isUserInteractionEnabled) {
        case (.standard, .normal, true):
            textLabel?.textColor = AccentColor.current.color
        case (.destructive, .normal, true):
            textLabel?.textColor = .systemRed
        case (_, _, _):
            textLabel?.textColor = .systemGray
        }
    }
}

// MARK: - CellProtocol

extension ActionCell: CellProtocol {
    
    static var identifier: String { "\(ActionCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? ActionItem else { return }
        
        isUserInteractionEnabled = item.isEnabled
        textLabel?.isUserInteractionEnabled = item.isEnabled
        
        textLabel?.text = item.text
        style = item.style
    }
}
