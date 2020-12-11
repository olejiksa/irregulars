//
//  TestItemsFactory.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class TestItemsFactory {
    
    private let languageService: LanguageService
    private let sentencesService: SentencesService
    
    init(languageService: LanguageService,
         sentencesService: SentencesService) {
        self.languageService = languageService
        self.sentencesService = sentencesService
    }
    
    func build(with testKind: Test.Kind,
               verb: Verb,
               hint: @escaping StringBlock,
               didEndEntering: @escaping Block,
               play: @escaping  AudioBlock) -> [Section] {
        guard let simplePast = verb.simplePast,
              let pastParticiple = verb.pastParticiple else {
            return []
        }
        
        switch testKind {
        case .threeForms:
            return [Section(header: "Infinitive".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value)]),
                    Section(header: "Simple Past".localized,
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)].compactMap { $0 }),
                    Section(header: "Past Participle".localized,
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)].compactMap { $0 })]
        case .translation:
            guard languageService.hasTranslation else { return [] }
            
            return [Section(header: "Translation".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value.localized)]),
                    Section(header: "Infinitive".localized,
                            items: [InputItem(words: [verb.infinitive],
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)].compactMap { $0 }),
                    Section(header: "Simple Past".localized,
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)].compactMap { $0 }),
                    Section(header: "Past Participle".localized,
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)].compactMap { $0 })]
        case .retranslation:
            guard languageService.hasTranslation else { return [] }
            
            return [Section(header: "Translation".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value.localized)].compactMap { $0 }),
                    Section(header: "Infinitive".localized,
                            items: [InputItem(words: [verb.infinitive],
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)].compactMap { $0 })]
        case .listening:
            guard UserDefaults.standard.bool(for: .listening) else { return [] }
            
            return [Section(items: [PlainDetailItem(text: "Listen and write".localized,
                                                    textStyle: .caption)].compactMap { $0 }),
                    Section(header: "Infinitive".localized,
                            items: [InputItem(words: [verb.infinitive],
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true)].compactMap { $0 }),
                    Section(header: "Simple Past".localized,
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true)].compactMap { $0 }),
                    Section(header: "Past Participle".localized,
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true)].compactMap { $0 })]
        case .sentences:
            let filteredArray = sentencesService.items.filter { $0.word == verb.infinitive.value }
            guard let randomSentenceString = filteredArray.randomElement()?.sentences.randomElement(),
                  let verbForms = sentencesService.ejectAppropriateVerbForms(for: randomSentenceString, from: verb) else { return []  }
            
            let replacedSentence = sentencesService.replaceSentence(randomSentenceString, using: verb)
            
            return [Section(header: "Sentence".localized,
                            items: [PlainDetailItem(text: replacedSentence)]),
                    Section(header: "Missed word".localized,
                            items: [InputItem(words: verbForms.map { Word.init(value: $0, transcription: "") },
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint)])]
        }
    }
}
