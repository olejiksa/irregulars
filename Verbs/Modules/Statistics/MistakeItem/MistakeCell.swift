//
//  MistakeCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class MistakeCell: UITableViewCell {

    @IBOutlet private weak var starButton: UIButton!
    @IBOutlet private weak var contentLabel: UILabel!
    
    private var actionBlock: BoolBlock?
    private var isFavorite = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        starButton.accessibilityLabel = "add_to_favorites".localized
    }
}

// MARK: - Private

private extension MistakeCell {
    
    @IBAction func didStarTap() {
        isFavorite = !isFavorite
        actionBlock?(isFavorite)
        
        if isFavorite {
            starButton.setImage(SystemIcon.starFill.image, for: .normal)
            starButton.accessibilityLabel = "remove_from_favorites".localized
        } else {
            starButton.setImage(SystemIcon.star.image, for: .normal)
            starButton.accessibilityLabel = "add_to_favorites".localized
        }
    }
}

// MARK: - CellProtocol

extension MistakeCell: CellProtocol {
    
    static var identifier: String { "\(MistakeCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? MistakeItem else { return }
        
        contentLabel.text = item.verb.infinitive.value
        actionBlock = item.actionBlock
    }
}
