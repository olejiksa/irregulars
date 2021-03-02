//
//  BigButtonItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

struct BigButtonItem {
    
    enum Style {
        case primary
        case secondary
    }
    
    let text: String
    let style: Style
    let actionBlock: Block
}
