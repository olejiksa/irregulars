//
//  TableViewSection.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct TableViewSection {
    
    let header: String?
    let items: [ItemProtocol]
    let footer: String?
    
    init(header: String? = nil, items: [ItemProtocol], footer: String? = nil) {
        self.header = header
        self.items = items
        self.footer = footer
    }
}
