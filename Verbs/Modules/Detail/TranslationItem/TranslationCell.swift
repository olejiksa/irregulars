//
//  TranslationCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TranslationCell: UITableViewCell {
    
    @IBOutlet private weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

extension TranslationCell: CellProtocol {
    
    static var identifier: String { "\(TranslationCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? TranslationItem else { return }
        
        contentLabel.text = item.text
    }
}
