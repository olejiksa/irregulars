//
//  SidebarCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SidebarCell: UICollectionViewListCell {
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newBackgroundConfiguration = UIBackgroundConfiguration.listSidebarCell()
        
        if state.isSelected {
            newBackgroundConfiguration.backgroundColor = nil
        }
        
        backgroundConfiguration = newBackgroundConfiguration
    }
}
