//
//  Word.swift
//  Verbs
//
//  Created by Oleg Samoylov on 15.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct Word: Codable {
    
    let value: String
    let transcription: String
    
    init() {
        value = ""
        transcription = ""
    }
    
    init(value: String, transcription: String) {
        self.value = value
        self.transcription = transcription
    }
}

// MARK: - Comparable

extension Word: Comparable {
    
    static func <(lhs: Word, rhs: Word) -> Bool {
        lhs.value < rhs.value
    }
}
