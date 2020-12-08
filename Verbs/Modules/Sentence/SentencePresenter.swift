//
//  SentencePresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 06.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SentencePresenter: NSObject {
    
    private let verbsService: VerbsService
    private let sentencesService: SentencesService
    private var items: [String] = []
    
    var router: TestDetailRouter?
    weak var viewController: SentenceViewController?
    let dataSource = SectionDataSource()
    
    init(verbsService: VerbsService,
         sentencesService: SentencesService) {
        self.verbsService = verbsService
        self.sentencesService = sentencesService
        self.items = verbsService.items.map { $0.infinitive.value }
        super.init()
        loadSettings()
        setupSections()
    }
}

// MARK: - Private

private extension SentencePresenter {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.standard.bool(for: .shouldRegularVerbsBeShown)
        verbsService.shouldDerivedFormsBeShown = UserDefaults.standard.bool(for: .shouldDerivedFormsBeShown)
        verbsService.shouldTranslationBeShown = UserDefaults.standard.bool(for: .shouldTranslationBeShown)
    }
    
    func setupSections() {
        configureRandomComposition()
    }
    
    func configureRandomComposition() {
        guard !items.isEmpty else {
            router?.goBack()
            return
        }
        
        guard let verb = verbsService.verb(of: items.randomElement()),
              let index = items.firstIndex(of: verb.infinitive.value)
        else {
            configureRandomComposition()
            return
        }
        
        items.remove(at: index)
        
        let filteredArray = sentencesService.items.filter { $0.word == verb.infinitive.value }
        guard let randomSentenceString = filteredArray.randomElement()?.sentences.randomElement(),
              let verbForms = ejectAppropriateVerbForms(for: randomSentenceString, from: verb) else {
            configureRandomComposition()
            return
        }
        
        let replacedSentence = replaceSentence(randomSentenceString, using: verb)
        
        dataSource.setup([Section(header: "Sentence".localized,
                                  items: [PlainDetailItem(text: replacedSentence)]),
                          Section(header: "Missed word".localized,
                                  items: [InputItem(words: verbForms.map { Word.init(value: $0, transcription: "") },
                                                    successActionBlock: didEndEntering,
                                                    hintActionBlock: show)])])
    }
    
    func didEndEntering() {
        guard let items = dataSource.items(of: InputItem.self) as? [InputItem],
              items.allSatisfy({ $0.isFilled }) else { return }
        
        configureRandomComposition()
        viewController?.reloadData()
    }
    
    func show(hint: String) {
        router?.show(hint: hint)
    }
    
    func ejectAppropriateVerbForms(for sentence: String, from verb: Verb) -> [String]? {
        if contains(in: verb.infinitive.value, sentence: sentence) {
            return [verb.infinitive.value]
        } else {
            let isSimplePast = verb.simplePast.contains { contains(in: $0.value, sentence: sentence) }
            if isSimplePast { return verb.simplePast.map { $0.value } }
            
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
            if let simplePast = verb.simplePast.first(where: { contains(in: $0.value, sentence: sentence) })?.value {
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

// MARK: - UITableViewDelegate

extension SentencePresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
