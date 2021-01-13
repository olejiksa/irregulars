//
//  String.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: [CVarArg]) -> String {
        .init(format: localized, locale: nil, arguments: arguments)
    }
    
    func containsWordIgnoringCase<T>(_ other: T) -> Bool where T: StringProtocol {
        guard !other.isEmpty else { return false }
        
        for item in lowercased().split(separator: ",") {
            let string = String(item).trimmingCharacters(in: .whitespacesAndNewlines)
            guard string.hasPrefix(other.lowercased()) else { continue }
            return true
        }
        
        return false
    }
    
    func hasPrefixIgnoringCase<T>(_ other: T) -> Bool where T: StringProtocol {
        guard !other.isEmpty else { return false }
        
        return lowercased().hasPrefix(other.lowercased())
    }
}
