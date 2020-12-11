//
//  StatisticsHeaderCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StatisticsHeaderCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

extension StatisticsHeaderCell: CellProtocol {
    
    static var identifier: String { "\(StatisticsHeaderCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? StatisticsHeaderItem else { return }
        
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}
