//
//  DetailItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct DetailItem {
    
    let caption: String
    let title: String
    let actionBlock: ((String) -> ())
    
    init?(caption: String,
          title: String?,
          actionBlock: @escaping ((String) -> ())) {
        guard let title = title else { return nil }
        self.caption = caption
        self.title = title
        self.actionBlock = actionBlock
    }
}
