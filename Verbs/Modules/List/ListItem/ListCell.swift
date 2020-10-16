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
}

// MARK: - CellProtocol

extension ListCell: CellProtocol {
    
    static var identifier: String { "\(ListCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? ListItem else { return }
        
        infinitiveLabel.text = item.verb.infinitive.value
        simplePastLabel.text = item.verb.simplePastShortened
        pastParticipleLabel.text = item.verb.pastParticipleShortened ?? "—"
    }
}
