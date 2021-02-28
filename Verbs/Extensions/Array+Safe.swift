//
//  Array+Safe.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

extension Array {
    
    subscript(safe index: Int) -> Element? {
        guard index < count else { return nil }
        return self[index]
    }
    
    func first(count: Int) -> [Element] {
        let minimum = Swift.min(count, self.count)
        return .init(self[0..<minimum])
    }
}
