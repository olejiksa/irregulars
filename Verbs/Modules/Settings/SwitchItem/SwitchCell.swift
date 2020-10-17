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
    @IBOutlet private weak var isOn: UISwitch!
    
    private var actionBlock: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

private extension SwitchCell {
    
    @IBAction func switchValueChanged() {
        actionBlock?(isOn.isOn)
    }
}

// MARK: - CellProtocol

extension SwitchCell: CellProtocol {
    
    static var identifier: String { "\(SwitchCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? SwitchItem else { return }
        
        contentLabel.text = item.text
        isOn.isOn = item.isOn
        actionBlock = item.actionBlock
        
        isUserInteractionEnabled = item.isEnabled
        contentLabel?.isEnabled = item.isEnabled
        isOn?.isEnabled = item.isEnabled
    }
}
