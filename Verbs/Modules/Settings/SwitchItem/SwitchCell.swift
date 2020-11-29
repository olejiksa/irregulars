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
    
    private var item: SwitchItem?
    private var actionBlock: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

private extension SwitchCell {
    
    @IBAction func switchValueChanged() {
        actionBlock?(toggleSwitch.isOn)
        item?.isOn = toggleSwitch.isOn
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
        actionBlock = item.actionBlock
        
        isUserInteractionEnabled = item.isEnabled
        contentLabel?.isEnabled = item.isEnabled
        toggleSwitch?.isEnabled = item.isEnabled
        
        toggleSwitch.onTintColor = AccentColor.current.color
    }
}
