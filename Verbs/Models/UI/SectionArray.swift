//
//  SectionArray.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

struct SectionArray {
    
    private var sections: [TableViewSection] = []
    
    var count: Int {
        sections.filter { !$0.items.isEmpty }.count
    }
    
    func item(_ indexPath: IndexPath) -> ItemProtocol? {
        sections.filter { !$0.items.isEmpty }[safe: indexPath.section]?.items[safe: indexPath.row]
    }
    
    func header(_ index: Int) -> String? {
        sections.filter { !$0.items.isEmpty }[safe: index]?.header
    }
    
    func footer(_ index: Int) -> String? {
        sections.filter { !$0.items.isEmpty }[safe: index]?.footer
    }
    
    func count(_ index: Int) -> Int {
        sections.filter { !$0.items.isEmpty }[index].items.count
    }
    
    func items<T>(of type: T.Type) -> [ItemProtocol] where T: ItemProtocol {
        let items = sections.flatMap(\.items)
        return items.filter { $0 is T }
    }
    
    mutating func setup(_ sections: [TableViewSection]) {
        self.sections = sections
    }
}
