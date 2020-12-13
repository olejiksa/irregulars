//
//  AnswerCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 13.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AnswerCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var item: AnswerItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        accessoryType = .disclosureIndicator
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected, let item = item else { return }
        
        if item.isCorrect {
            let attributeString = NSMutableAttributedString(string: item.text)
            attributeString.addAttribute(.foregroundColor,
                                         value: AccentColor.current.color,
                                         range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
        } else {
            let attributeString = NSMutableAttributedString(string: item.text)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: 2,
                                         range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        item = nil
        titleLabel.attributedText = NSAttributedString(string: "")
    }
}

// MARK: - CellProtocol

extension AnswerCell: CellProtocol {
    
    static var identifier: String { "\(AnswerCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? AnswerItem else { return }
        self.item = item
        titleLabel.attributedText = NSAttributedString(string: item.text)
    }
}
