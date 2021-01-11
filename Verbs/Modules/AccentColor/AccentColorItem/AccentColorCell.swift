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
    
    private weak var item: AccentColorItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorInset = .init(top: 0, left: 66, bottom: 0, right: 0)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        applyColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        circleView.color = .systemGray
    }
}

// MARK: - Private

private extension AccentColorCell {
    
    func applyColor() {
        if tintAdjustmentMode != .dimmed {
            circleView.color = item?.color.color ?? .systemGray
        } else {
            circleView.color = .systemGray
        }
    }
}

// MARK: - CellProtocol

extension AccentColorCell: CellProtocol {
    
    static var identifier: String { "\(AccentColorCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? AccentColorItem else { return }
        self.item = item
        colorNameLabel?.text = item.color.rawValue.localized
        applyColor()
    }
}
