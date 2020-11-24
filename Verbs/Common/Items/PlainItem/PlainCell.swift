//
//  PlainCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PlainCell: UITableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let scene = UIApplication.shared.connectedScenes.first
        let sd = scene?.delegate as? SceneDelegate
        guard let splitVc = sd?.window?.rootViewController as? UISplitViewController,
              !splitVc.isCollapsed else { return }
        
        if selected {
            contentView.backgroundColor = .systemBlue
            [textLabel].forEach { $0?.textColor = .white }
        } else {
            contentView.backgroundColor = nil
            [textLabel].forEach { $0?.textColor = nil }
        }
    }
}

// MARK: - CellProtocol

extension PlainCell: CellProtocol {
    
    static var identifier: String { "\(PlainCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? PlainItem else { return }
        
        textLabel?.text = item.title
        accessoryType = item.hasDisclosureIndicator ? .disclosureIndicator : .none
    }
}
