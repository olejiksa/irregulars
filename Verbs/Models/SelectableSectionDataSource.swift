//
//  SelectableSectionDataSource.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SelectableSectionDataSource: SectionDataSource {
    
    var selectedIndexPath: IndexPath? = nil
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.accessoryType = selectedIndexPath == indexPath ? .checkmark : .none
        return cell
    }
}
