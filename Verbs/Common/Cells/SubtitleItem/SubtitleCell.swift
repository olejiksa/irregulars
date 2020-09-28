//
//  SubtitleCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SubtitleCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CellProtocol

extension SubtitleCell: CellProtocol {
    
    static var identifier: String { "\(SubtitleCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? SubtitleItem else { return }
        
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
    }
}
