//
//  Test.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

enum Test: Equatable {
    case level(Int)
    case favorites
    
    var indexPath: IndexPath {
        switch self {
        case .level(let index):
            return .init(row: index, section: 1)
        case .favorites:
            return .init(row: 0, section: 0)
        }
    }
    
    var title: String {
        switch self {
        case .level(let index):
            return "\("Level".localized) \(index + 1)"
        case .favorites:
            return "Favorites".localized
        }
    }
}
