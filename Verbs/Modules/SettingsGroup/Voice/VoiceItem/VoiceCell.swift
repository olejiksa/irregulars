//
//  VoiceCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class VoiceCell: UITableViewCell {}

// MARK: - CellProtocol

extension VoiceCell: CellProtocol {
    
    static var identifier: String { "\(VoiceCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? VoiceItem else { return }
        
        textLabel?.text = item.name
        detailTextLabel?.text = item.region.description.capitalized
    }
}
