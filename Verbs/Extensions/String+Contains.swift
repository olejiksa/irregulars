//
//  String+Contains.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

extension String {
    
    func containsIgnoringCase<T>(_ other: T) -> Bool where T : StringProtocol {
        lowercased().contains(other.lowercased())
    }
}
