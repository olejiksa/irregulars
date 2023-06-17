//
//  TestItemsFactory.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

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
               record: RecordBlock?,
               compare: RecordBlock?,
               answerActionBlock: @escaping ItemBlock) -> [Section] {
        guard let simplePast = verb.simplePast,
              let pastParticiple = verb.pastParticiple else {
            return []
        }
        
        switch testKind {
        case .twoForms:
            return [Section(header: .localized(.infinitive),
                            items: [PlainDetailItem(text: verb.infinitive.value)]),
                    Section(header: .localized(.pastSimple),
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 0)].compactMap { $0 }),
                    Section(header: .localized(.pastParticiple),
                            items: [InputItem(words: pastParticiple,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              tag: 1,
                                              returnKeyType: .done)].compactMap { $0 })]
        case .translation:
            guard languageService.hasTranslation else { return [] }
            
            let items = generateAnswerItems(count: 4, verb: verb, form: .translation,
                                            verbForms: [verb.translation],
                                            actionBlock: answerActionBlock)
            
            return [Section(header: .localized(.infinitive),
                            items: [PlainDetailItem(text: verb.infinitive.value)].compactMap { $0 }),
                    Section(header: .localized(.translation),
                            items: items.compactMap { $0 })]
        case .retranslation:
            guard languageService.hasTranslation else { return [] }
            
            let items = generateAnswerItems(count: 4, verb: verb, form: .infinitive,
                                            verbForms: [verb.infinitive.value],
                                            actionBlock: answerActionBlock)
            
            return [Section(header: .localized(.translation),
                            items: [PlainDetailItem(text: verb.translation)].compactMap { $0 }),
                    Section(header: .localized(.infinitive),
                            items: items.compactMap { $0 })]
        case .listening:
            return [Section(items: [PlainDetailItem(text: "listen_and_write".localized,
                                                    textStyle: .secondary)].compactMap { $0 }),
                    Section(header: .localized(.infinitive),
                            items: [InputItem(words: [verb.infinitive],
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true,
                                              tag: 0)].compactMap { $0 }),
                    Section(header: .localized(.pastSimple),
                            items: [InputItem(words: simplePast,
                                              playActionBlock: play,
                                              successActionBlock: didEndEntering,
                                              hintActionBlock: hint,
                                              isAudio: true,
                                              tag: 1)].compactMap { $0 }),
                    Section(header: .localized(.pastParticiple),
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
            
            return [Section(header: "sentence".localized,
                            items: [PlainDetailItem(text: replacedSentence)]),
                    Section(header: "missed_word".localized,
                            items: generateAnswerItems(count: 4,
                                                       verb: verb,
                                                       form: verbForms.0,
                                                       verbForms: verbForms.1,
                                                       actionBlock: answerActionBlock))]
        case .speaking:
            var notAllowedSection: Section?
            if !Locator.isMicrophoneAvailable {
                let notAllowedItem = PlainDetailItem(text: "insufficient_permissions".localized, textStyle: .primary)
                let actionItem = ActionItem(text: "allow_access".localized) { _ in
                    guard let url = URL(string: UIApplication.openSettingsURLString),
                          UIApplication.shared.canOpenURL(url) else { return }
                    UIApplication.shared.open(url)
                }
                
                notAllowedSection = .init(items: [notAllowedItem, actionItem])
            }
            
            return [notAllowedSection,
                    Section(items: [PlainDetailItem(text: "listen_and_record".localized,
                                                    textStyle: .secondary)].compactMap { $0 }),
                    Section(header: .localized(.infinitive),
                            items: [RecordItem(word: verb.infinitive,
                                               playActionBlock: play,
                                               recordActionBlock: record,
                                               compareActionBlock: compare,
                                               tag: 0)].compactMap { $0 }),
                    Section(header: .localized(.pastSimple),
                            items: simplePast.map { RecordItem(word: $0,
                                                               playActionBlock: play,
                                                               recordActionBlock: record,
                                                               compareActionBlock: compare,
                                                               tag: 1) }.compactMap { $0 }),
                    Section(header: .localized(.pastParticiple),
                            items: pastParticiple.map { RecordItem(word: $0,
                                                                   playActionBlock: play,
                                                                   recordActionBlock: record,
                                                                   compareActionBlock: compare,
                                                                   tag: 2,
                                                                   returnKeyType: .done) }.compactMap { $0 })].compactMap { $0 }
        }
    }
}

// MARK: - Private
 
private extension TestItemsFactory {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbsTests)
        verbsService.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivativesTests)
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
                guard let value = verb?.translation else { continue }
                formString = value
            }
            
            let answerItem = AnswerItem(text: formString, actionBlock: actionBlock)
            guard !answerItems.contains(where: { $0.text == answerItem.text }) else { continue }
            answerItems.insert(answerItem)
            index += 1
        }
        
        return .init(answerItems)
    }
}
