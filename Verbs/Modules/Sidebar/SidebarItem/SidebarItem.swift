//
//  SidebarItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

struct SidebarItem: Hashable, Identifiable {
    let id: UUID
    let type: SidebarItemType
    let title: String
    let subtitle: String?
    let image: UIImage?
    let isExpandable: Bool
    let accessibilityIdentifier: AccessibilityIdentifier?
    
    static func header(title: String,
                       isExpandable: Bool = false,
                       id: UUID = UUID(),
                       accessibilityIdentifier: AccessibilityIdentifier? = nil) -> Self {
        .init(id: id,
              type: .header,
              title: title,
              subtitle: nil,
              image: nil,
              isExpandable: isExpandable,
              accessibilityIdentifier: accessibilityIdentifier)
    }
    
    static func row(title: String,
                    subtitle: String? = nil,
                    image: UIImage? = nil,
                    isExpandable: Bool = false,
                    id: UUID = UUID(),
                    accessibilityIdentifier: AccessibilityIdentifier? = nil) -> Self {
        .init(id: id,
              type: .row,
              title: title,
              subtitle: subtitle,
              image: image,
              isExpandable: isExpandable,
              accessibilityIdentifier: accessibilityIdentifier)
    }
}

enum SidebarItemType: Int {
    case header, row
}
