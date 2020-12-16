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
    private let verbsService: VerbsService
    private let verbs: [Verb]
    
    init(languageService: LanguageService,
         sentencesService: SentencesService,
         verbsService: VerbsService) {
        self.languageService = languageService
        self.sentencesService = sentencesService
        self.verbsService = verbsService
        self.verbs = verbsService.items
        loadSettings()
    }
    
    func build(with testKind: Test.Kind,
               verb: Verb,
               hint: @escaping StringBlock,
               didEndEntering: @escaping Block,
               play: @escaping AudioBlock,
               answerActionBlock: @escaping ItemBlock) -> [Section] {
        guard let simplePast = verb.simplePast,
              let pastParticiple = verb.pastParticiple else {
            return []
        }
        
        switch testKind {
        case .twoForms:
            return [Section(header: "InfinitiveValue".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value)]),
                    Section(header: "SimplePastValue".localized,
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 0)].compactMap { $0 }),
                    Section(header: "PastParticipleValue".localized,
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 1,
                                              returnKeyType: .done)].compactMap { $0 })]
        case .threeForms:
            guard languageService.hasTranslation else { return [] }
            
            return [Section(header: "Translation".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value.localized)]),
                    Section(header: "InfinitiveValue".localized,
                            items: [InputItem(words: [verb.infinitive],
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 0)].compactMap { $0 }),
                    Section(header: "SimplePastValue".localized,
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 1)].compactMap { $0 }),
                    Section(header: "PastParticipleValue".localized,
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 2,
                                              returnKeyType: .done)].compactMap { $0 })]
        case .translation:
            guard languageService.hasTranslation else { return [] }
            
            let items = generateAnswerItems(count: 4, verb: verb, form: .translation,
                                            verbForms: [verb.infinitive.value.localized],
                                            actionBlock: answerActionBlock)
            
            return [Section(header: "InfinitiveValue".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value)].compactMap { $0 }),
                    Section(header: "Translation".localized,
                            items: items.compactMap { $0 })]
        case .retranslation:
            guard languageService.hasTranslation else { return [] }
            
            let items = generateAnswerItems(count: 4, verb: verb, form: .infinitive,
                                            verbForms: [verb.infinitive.value],
                                            actionBlock: answerActionBlock)
            
            return [Section(header: "Translation".localized,
                            items: [PlainDetailItem(text: verb.infinitive.value.localized)].compactMap { $0 }),
                    Section(header: "InfinitiveValue".localized,
                            items: items.compactMap { $0 })]
        case .listening:
            return [Section(items: [PlainDetailItem(text: "Listen and write".localized,
                                                    textStyle: .secondary)].compactMap { $0 }),
                    Section(header: "InfinitiveValue".localized,
                            items: [InputItem(words: [verb.infinitive],
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true,
                                              tag: 0)].compactMap { $0 }),
                    Section(header: "SimplePastValue".localized,
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true,
                                              tag: 1)].compactMap { $0 }),
                    Section(header: "PastParticipleValue".localized,
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true,
                                              tag: 2,
                                              returnKeyType: .done)].compactMap { $0 })]
        case .sentences:
            let filteredArray = sentencesService.items.filter { $0.word == verb.infinitive.value }
            guard let randomSentenceString = filteredArray.randomElement()?.sentences.randomElement(),
                  let verbForms = sentencesService.ejectAppropriateVerbForms(for: randomSentenceString, from: verb) else { return []  }
            
            let replacedSentence = sentencesService.replaceSentence(randomSentenceString, using: verb)
            
            return [Section(header: "Sentence".localized,
                            items: [PlainDetailItem(text: replacedSentence)]),
                    Section(header: "Missed word".localized,
                            items: generateAnswerItems(count: 4,
                                                       verb: verb,
                                                       form: verbForms.0,
                                                       verbForms: verbForms.1,
                                                       actionBlock: answerActionBlock))]
        }
    }
}

// MARK: - Private
 
private extension TestItemsFactory {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .shouldRegularVerbsBeShown)
        verbsService.shouldDerivedFormsBeShown = UserDefaults.shared.bool(for: .shouldDerivedFormsBeShown)
    }
    
    func generateAnswerItems(count: Int,
                             verb: Verb,
                             form: Verb.Form,
                             verbForms: [String],
                             actionBlock: @escaping ItemBlock) -> [AnswerItem] {
        var answerItems = Set<AnswerItem>()
        let correctAnswerItem = AnswerItem(text: verbForms.randomElement() ?? "",
                                           actionBlock: actionBlock,
                                           isCorrect: true)
        answerItems.insert(correctAnswerItem)
        
        var index = 0
        while index < count - 1 {
            let formString: String
            let verb = verbs.randomElement()
            switch form {
            case .infinitive:
                guard let value = verb?.infinitive.value else { continue }
                formString = value
            case .simplePast:
                guard let value = verb?.simplePast?.randomElement()?.value else { continue }
                formString = value
            case .pastParticiple:
                guard let value = verb?.pastParticiple?.randomElement()?.value else { continue }
                formString = value
            case .translation:
                guard let value = verb?.infinitive.value.localized else { continue }
                formString = value
            }
            
            let answerItem = AnswerItem(text: formString, actionBlock: actionBlock)
            guard !answerItems.contains(where: { $0.text == answerItem.text }) else { continue }
            answerItems.insert(answerItem)
            index += 1
        }
        
        return Array(answerItems)
    }
}
