//
//  Sentence.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct Sentence: Decodable {
    
    let word: String
    let sentences: [String]
}
