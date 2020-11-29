//
//  AppIcon.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum AppIcon: Equatable {
    case standard
    case alternate(AccentColor)
    
    init(color: AccentColor) {
        switch color {
        case .blue:
            self = .standard
        default:
            self = .alternate(color)
        }
    }
    
    init(string: String?) {
        guard let string = string,
              let color = AccentColor(rawValue: string) else {
            self = .standard
            return
        }
        
        self.init(color: color)
    }
    
    var name: String? {
        switch self {
        case .standard:
            return nil
        case .alternate(let accentColor):
            return accentColor.rawValue
        }
    }
}
