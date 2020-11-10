//
//  SidebarItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

struct SidebarItem: Hashable, Swift.Identifiable {
    let id: UUID
    let type: SidebarItemType
    let title: String
    let subtitle: String?
    let image: UIImage?
    
    static func header(title: String, id: UUID = UUID()) -> Self {
        .init(id: id, type: .header, title: title, subtitle: nil, image: nil)
    }
    
    static func expandableRow(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
        .init(id: id, type: .expandableRow, title: title, subtitle: subtitle, image: image)
    }
    
    static func row(title: String, subtitle: String?, image: UIImage?, id: UUID = UUID()) -> Self {
        .init(id: id, type: .row, title: title, subtitle: subtitle, image: image)
    }
}

enum SidebarItemType: Int {
    case header, row, expandableRow
}
