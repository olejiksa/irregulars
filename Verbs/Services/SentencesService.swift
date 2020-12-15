//
//  SentencesService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class SentencesService {
    
    private let parser = JSONParser<Sentence>()

    private(set) var items: [Sentence] = []
    
    init() {
        setItems()
    }
    
    func ejectAppropriateVerbForms(for sentence: String, from verb: Verb) -> (Verb.Form, [String])? {
        if contains(verb.infinitive.value, in: sentence) {
            return (.infinitive, [verb.infinitive.value])
        } else {
            let isSimplePast = verb.simplePast?.contains { contains($0.value, in: sentence) } ?? false
            if isSimplePast { return (.simplePast, verb.simplePast?.map { $0.value } ?? []) }
            
            let isPastParticiple = verb.pastParticiple?.contains { contains($0.value, in: sentence) } ?? false
            if isPastParticiple { return (.pastParticiple, verb.pastParticiple?.map { $0.value } ?? []) }
            
            return nil
        }
    }
    
    func replaceSentence(_ sentence: String, using verb: Verb) -> String {
        let spacer = "..."
        if contains(verb.infinitive.value, in: sentence) {
            return sentence.replacingOccurrences(of: verb.infinitive.value,
                                                 with: spacer,
                                                 options: .caseInsensitive)
        } else if let simplePast = verb.simplePast?.first(where: { contains($0.value, in: sentence) })?.value {
            return sentence.replacingOccurrences(of: simplePast,
                                                 with: spacer,
                                                 options: .caseInsensitive)
        } else if let pastParticiple = verb.pastParticiple?.first(where: { contains($0.value, in: sentence) })?.value {
            return sentence.replacingOccurrences(of: pastParticiple,
                                                 with: spacer,
                                                 options: .caseInsensitive)
        } else {
            return sentence
        }
    }
    
    func contains(_ string: String, in sentence: String) -> Bool {
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
