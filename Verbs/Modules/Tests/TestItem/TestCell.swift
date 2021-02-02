//
//  TestCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestCell: UITableViewCell {
    
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
}

// MARK: - CellProtocol

extension TestCell: CellProtocol {
    
    static var identifier: String { "\(TestCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? TestItem else { return }
        
        titleLabel.text = item.title
        subtitleLabel?.text = item.subtitle
        iconImageView.image = item.icon.image
        
        accessibilityIdentifier = item.accessibilityIdentifier?.rawValue
    }
}
