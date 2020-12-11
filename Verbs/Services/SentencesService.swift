//
//  SentencesService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class SentencesService {
    
    private let parser = JSONParser<Sentence>()

    private(set) var items: [Sentence] = []
    
    init() {
        setItems()
    }
    
    func ejectAppropriateVerbForms(for sentence: String, from verb: Verb) -> [String]? {
        if contains(in: verb.infinitive.value, sentence: sentence) {
            return [verb.infinitive.value]
        } else {
            let isSimplePast = verb.simplePast?.contains { contains(in: $0.value, sentence: sentence) } ?? false
            if isSimplePast { return verb.simplePast?.map { $0.value } }
            
            let isPastParticiple = verb.pastParticiple?.contains { contains(in: $0.value, sentence: sentence) } ?? false
            if isPastParticiple { return verb.pastParticiple?.map { $0.value } }
            
            return nil
        }
    }
    
    func replaceSentence(_ sentence: String, using verb: Verb) -> String {
        let spacer = "..."
        if contains(in: verb.infinitive.value, sentence: sentence) {
            return sentence.replacingOccurrences(of: verb.infinitive.value, with: spacer)
        } else {
            if let simplePast = verb.simplePast?.first(where: { contains(in: $0.value, sentence: sentence) })?.value {
                return sentence.replacingOccurrences(of: simplePast, with: spacer)
            }
            
            if let pastParticiple = verb.pastParticiple?.first(where: { contains(in: $0.value, sentence: sentence) })?.value {
                return sentence.replacingOccurrences(of: pastParticiple, with: spacer)
            }
            
            return sentence
        }
    }
    
    func contains(in string: String, sentence: String) -> Bool {
        let pattern = "\\b\(string)\\b"
        return sentence.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }
}

// MARK: - Private

private extension SentencesService {
    
    func setItems() {
        items = parser.read(from: .sentences)
    }
}
