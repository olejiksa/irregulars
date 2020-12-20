//
//  VoiceItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class VoiceItem {
    
    let name: String
    let gender: Gender
    let region: Region
    
    init(name: String,
         gender: Gender,
         region: Region) {
        self.name = name
        self.gender = gender
        self.region = region
    }
}

// MARK: - ItemProtocol

extension VoiceItem: ItemProtocol {
    
    var identifier: String { VoiceCell.identifier }
}

