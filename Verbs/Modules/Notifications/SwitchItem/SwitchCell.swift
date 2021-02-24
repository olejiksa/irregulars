//
//  SwitchCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SwitchCell: UITableViewCell {

    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var toggleSwitch: UISwitch!
    
    private weak var item: SwitchItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        applyColor()
    }
}

// MARK: - Private

private extension SwitchCell {
    
    func applyColor() {
        switch tintAdjustmentMode {
        case .dimmed:
            toggleSwitch.onTintColor = .systemGray
        default:
            #if targetEnvironment(macCatalyst)
            toggleSwitch.onTintColor = UIButton().tintColor
            #else
            toggleSwitch.onTintColor = AccentColor.current.color
            #endif
        }
    }
    
    @IBAction func switchValueChanged() {
        item?.isOn = toggleSwitch.isOn
        item?.actionBlock(toggleSwitch.isOn)
    }
}

// MARK: - CellProtocol

extension SwitchCell: CellProtocol {
    
    static var identifier: String { "\(SwitchCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? SwitchItem else { return }
        self.item = item
        
        contentLabel.text = item.text
        toggleSwitch.isOn = item.isOn
        
        isUserInteractionEnabled = item.isEnabled
        contentLabel?.isEnabled = item.isEnabled
        toggleSwitch?.isEnabled = item.isEnabled
        
        applyColor()
    }
}
