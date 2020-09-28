//
//  TableView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(_ cells: Identifiable.Type...) {
        for cell in cells {
            let nib = UINib(nibName: cell.identifier, bundle: .main)
            register(nib, forCellReuseIdentifier: cell.identifier)
        }
    }
    
    func dequeueReusableCell(for item: ItemProtocol, at indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        (cell as? CellProtocol)?.setup(with: item)
        return cell
    }
}
