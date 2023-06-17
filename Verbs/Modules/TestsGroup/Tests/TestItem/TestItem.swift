//
//  TestItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 05.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct TestItem {
    
    let icon: SystemIcon
    let title: String?
    let subtitle: String?
    let test: Test?
    let accessibilityIdentifier: AccessibilityIdentifier?
    
    internal init(icon: SystemIcon,
                  title: String? = nil,
                  subtitle: String? = nil,
                  test: Test? = nil,
                  accessibilityIdentifier: AccessibilityIdentifier? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.test = test
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - ItemProtocol

extension TestItem: ItemProtocol {
    
    var identifier: String { TestCell.identifier }
}
