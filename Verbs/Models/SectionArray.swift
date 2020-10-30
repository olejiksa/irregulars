//
//  SectionArray.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct SectionArray {
    
    private var sections: [Section] = []
    
    var count: Int {
        sections.filter { !$0.items.isEmpty }.count
    }
    
    func item(_ indexPath: IndexPath) -> ItemProtocol {
        sections.filter { !$0.items.isEmpty }[indexPath.section].items[indexPath.row]
    }
    
    func header(_ index: Int) -> String? {
        sections.filter { !$0.items.isEmpty }[index].header
    }
    
    func count(_ index: Int) -> Int {
        sections.filter { !$0.items.isEmpty }[index].items.count
    }
    
    mutating func setup(_ sections: [Section]) {
        self.sections = sections
    }
}
