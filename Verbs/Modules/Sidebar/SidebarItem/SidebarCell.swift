//
//  SidebarCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SidebarCell: UICollectionViewListCell {
    
    var item: SidebarItem? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        updateBackgroundConfiguration(using: state)
        updateContentConfiguration(using: state)
    }
}

// MARK: - Private

private extension SidebarCell {
    
    func updateBackgroundConfiguration(using state: UICellConfigurationState) {
        backgroundConfiguration = .listCell()
    }
    
    func updateContentConfiguration(using state: UICellConfigurationState) {
        var newContentConfiguration = UIListContentConfiguration.cell()
        
        newContentConfiguration.text = item?.title
        newContentConfiguration.secondaryText = item?.subtitle
        newContentConfiguration.image = item?.image
        
        contentConfiguration = newContentConfiguration
    }
}
