//
//  SubtitleCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SubtitleCell: UITableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let scene = UIApplication.shared.connectedScenes.first
        let sd = scene?.delegate as! SceneDelegate
        guard let splitVc = sd.window?.rootViewController as? UISplitViewController,
              !splitVc.isCollapsed else { return }
        
        if selected {
            contentView.backgroundColor = .systemBlue
            [textLabel, detailTextLabel].forEach { $0?.textColor = .white }
        } else {
            contentView.backgroundColor = nil
            [textLabel, detailTextLabel].forEach { $0?.textColor = nil }
        }
    }
}

// MARK: - CellProtocol

extension SubtitleCell: CellProtocol {
    
    static var identifier: String { "\(SubtitleCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? SubtitleItem else { return }
        
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
        accessoryType = item.hasDisclosureIndicator ? .disclosureIndicator : .none
    }
}
