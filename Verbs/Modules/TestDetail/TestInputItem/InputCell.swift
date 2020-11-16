//
//  InputCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class InputCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}

// MARK: - Private

private extension InputCell {
    
    
}

// MARK: - CellProtocol

extension InputCell: CellProtocol {
    
    static var identifier: String { "\(InputCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? InputItem else { return }
    }
}
