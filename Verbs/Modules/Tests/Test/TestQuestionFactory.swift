//
//  TestQuestionFactory.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

@MainActor
final class TestQuestionFactory {
    
    private let languageService: LanguageService
    private let sentencesService: SentencesService
    private let verbs: [Verb]
    
    init(languageService: LanguageService,
         sentencesService: SentencesService,
         verbsService: VerbsService) {
        self.languageService = languageService
        self.sentencesService = sentencesService
        
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        verbsService.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
        verbs = verbsService.items
    }
    
    func build(with testKind: Test.Kind, verb: Verb) -> [TestSection] {
        guard let simplePast = verb.simplePast,
              let pastParticiple = verb.pastParticiple else { return [] }
        
        switch testKind {
        case .twoForms:
            return numbered([
                (String(localized: "infinitive"), [.plain(plain(verb.infinitive.value))]),
                (String(localized: "past_simple"), [.input(InputField(id: 0,
                                                             words: simplePast,
                                                             isAudio: false,
                                                             isLast: false))]),
                (String(localized: "past_participle"), [.input(InputField(id: 1,
                                                                 words: pastParticiple,
                                                                 isAudio: false,
                                                                 isLast: true))])
            ])
        case .translation:
            guard languageService.hasTranslation else { return [] }
            
            return numbered([
                (String(localized: "infinitive"), [.plain(plain(verb.infinitive.value))]),
                (String(localized: "translation"), answers(for: verb, form: .translation, correct: [verb.translation]))
            ])
        case .retranslation:
            guard languageService.hasTranslation else { return [] }
            
            return numbered([
                (String(localized: "translation"), [.plain(plain(verb.translation))]),
                (String(localized: "infinitive"), answers(for: verb, form: .infinitive, correct: [verb.infinitive.value]))
            ])
        case .listening:
            return numbered([
                (nil, [.plain(plain("listen_and_write".localized, isSecondary: true))]),
                (String(localized: "infinitive"), [.input(InputField(id: 0,
                                                             words: [verb.infinitive],
                                                             isAudio: true,
                                                             isLast: false))]),
                (String(localized: "past_simple"), [.input(InputField(id: 1,
                                                             words: simplePast,
                                                             isAudio: true,
                                                             isLast: false))]),
                (String(localized: "past_participle"), [.input(InputField(id: 2,
                                                                 words: pastParticiple,
                                                                 isAudio: true,
                                                                 isLast: true))])
            ])
        case .sentences:
            let filtered = sentencesService.items.filter { $0.word == verb.infinitive.value }
            guard let sentence = filtered.randomElement()?.sentences.randomElement(),
                  let verbForms = sentencesService.ejectAppropriateVerbForms(for: sentence, from: verb)
            else { return [] }
            
            let replaced = sentencesService.replaceSentence(sentence, using: verb)
            
            return numbered([
                ("sentence".localized, [.plain(plain(replaced))]),
                ("missed_word".localized, answers(for: verb, form: verbForms.0, correct: verbForms.1))
            ])
        case .speaking:
            var sections: [(String?, [TestRow])] = []
            
            if !Locator.isMicrophoneAvailable {
                sections.append((nil, [.plain(plain("insufficient_permissions".localized)),
                                       .action(ActionRow(id: "allow-access",
                                                         title: "allow_access".localized))]))
            }
            
            sections.append((nil, [.plain(plain("listen_and_record".localized, isSecondary: true))]))
            sections.append((String(localized: "infinitive"), [.record(RecordField(word: verb.infinitive, tag: 0, index: 0))]))
            sections.append((String(localized: "past_simple"), simplePast.enumerated().map { index, word in
                .record(RecordField(word: word, tag: 1, index: index))
            }))
            sections.append((String(localized: "past_participle"), pastParticiple.enumerated().map { index, word in
                .record(RecordField(word: word, tag: 2, index: index))
            }))
            
            return numbered(sections)
        }
    }
}

// MARK: - Private

private extension TestQuestionFactory {
    
    func plain(_ text: String, isSecondary: Bool = false) -> PlainRow {
        PlainRow(id: text, text: text, isSecondary: isSecondary)
    }
    
    func numbered(_ sections: [(String?, [TestRow])]) -> [TestSection] {
        sections.enumerated().map { index, section in
            TestSection(id: index, header: section.0, rows: section.1)
        }
    }
    
    /// One correct answer and three wrong ones drawn from the other verbs, shuffled.
    func answers(for verb: Verb, form: Verb.Form, correct: [String]) -> [TestRow] {
        var texts: [String] = [correct.randomElement() ?? ""]
        
        var attempts = 0
        while texts.count < 4 && attempts < 1000 {
            attempts += 1
            
            guard let other = verbs.randomElement(), let text = value(of: other, form: form) else { continue }
            guard !texts.contains(text) else { continue }
            
            texts.append(text)
        }
        
        let correctText = texts[0]
        return texts
            .shuffled()
            .map { .answer(AnswerRow(id: $0, text: $0, isCorrect: $0 == correctText)) }
    }
    
    func value(of verb: Verb, form: Verb.Form) -> String? {
        switch form {
        case .infinitive:
            return verb.infinitive.value
        case .simplePast:
            return verb.simplePast?.randomElement()?.value
        case .pastParticiple:
            return verb.pastParticiple?.randomElement()?.value
        case .translation:
            return verb.translation
        }
    }
}
