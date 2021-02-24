//
//  ListCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ListCell: UITableViewCell {
    
    @IBOutlet private weak var infinitiveLabel: UILabel!
    @IBOutlet private weak var simplePastLabel: UILabel!
    @IBOutlet private weak var pastParticipleLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        applyColor()
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        
        applyColor()
    }
}

// MARK: - Private

private extension ListCell {
    
    func applyColor() {
        let scene = UIApplication.shared.connectedScenes.first
        let sd = scene?.delegate as? SceneDelegate
        let splitVc = sd?.window?.rootViewController as? UISplitViewController
        let isSelected = self.isSelected && splitVc?.isCollapsed == false
        
        switch (isSelected, tintAdjustmentMode) {
        case (true, .normal):
            #if !targetEnvironment(macCatalyst)
            contentView.backgroundColor = AccentColor.current.color
            #else
            contentView.backgroundColor = UIButton().tintColor
            #endif
            [infinitiveLabel, simplePastLabel, pastParticipleLabel].forEach { $0.textColor = .white }
        case (true, _):
            contentView.backgroundColor = .systemGray
            [infinitiveLabel, simplePastLabel, pastParticipleLabel].forEach { $0.textColor = .white }
        case (false, _):
            contentView.backgroundColor = nil
            [infinitiveLabel, simplePastLabel, pastParticipleLabel].forEach { $0.textColor = nil }
        }
    }
}

// MARK: - CellProtocol

extension ListCell: CellProtocol {
    
    static var identifier: String { "\(ListCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? ListItem else { return }
        
        infinitiveLabel.text = item.verb.infinitive.value
        simplePastLabel.text = item.verb.simplePast?.first?.value ?? "—"
        pastParticipleLabel.text = item.verb.pastParticiple?.first?.value ?? "—"
    }
}
