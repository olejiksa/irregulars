//
//  TestDetailPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestDetailPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    var router: TestDetailRouter?
    weak var viewController: TestDetailViewController?
    
    private var items: [String]
    private let audioService: AudioService
    private let verbsService: VerbsService
    private let favoritesService: FavoritesService
    private let languageService: LanguageService
    private var currentTestKind: TestKind?
    
    init(audioService: AudioService,
         verbsService: VerbsService,
         favoritesService: FavoritesService,
         languageService: LanguageService) {
        self.verbsService = verbsService
        self.favoritesService = favoritesService
        self.items = UserDefaults.standard.bool(for: .favoritesOnly)
            ? favoritesService.items.map { $0.infinitive.value }
            : verbsService.items.map { $0.infinitive.value }
        self.audioService = audioService
        self.languageService = languageService
        super.init()
        
        loadSettings()
        setupSections()
    }
}

// MARK: - Private

private extension TestDetailPresenter {
    
    func loadSettings() {
        verbsService.shouldRegularVerbsBeShown = UserDefaults.standard.bool(for: .shouldRegularVerbsBeShown)
        verbsService.shouldDerivedFormsBeShown = UserDefaults.standard.bool(for: .shouldDerivedFormsBeShown)
    }
    
    func setupSections() {
        configureRandomComposition()
    }
    
    func configureRandomComposition() {
        guard !items.isEmpty else {
            router?.goBack()
            return
        }
        
        let verbWrapped = UserDefaults.standard.bool(for: .favoritesOnly)
            ? favoritesService.verb(of: items.randomElement())
            : verbsService.verb(of: items.randomElement())
        
        guard let verb = verbWrapped,
              let index = items.firstIndex(of: verb.infinitive.value),
              let simplePast = verb.simplePast,
              let pastParticiple = verb.pastParticiple
        else {
            configureRandomComposition()
            viewController?.reloadData()
            return
        }
        
        items.remove(at: index)
        
        currentTestKind = TestKind.allCases.randomElement()
        
        switch currentTestKind {
        case .threeForms:
            dataSource.setup([Section(header: "Infinitive".localized,
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
                                                        hintActionBlock: hint)].compactMap { $0 })])
        case .translation:
            guard languageService.hasTranslation else {
                configureRandomComposition()
                viewController?.reloadData()
                return
            }
            
            dataSource.setup([Section(header: "Translation".localized,
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
                                                        hintActionBlock: hint)].compactMap { $0 })])
        case .retranslation:
            guard languageService.hasTranslation else {
                configureRandomComposition()
                viewController?.reloadData()
                return
            }
            
            dataSource.setup([Section(header: "Translation".localized,
                                      items: [PlainDetailItem(text: verb.infinitive.value.localized)].compactMap { $0 }),
                              Section(header: "Infinitive".localized,
                                      items: [InputItem(words: [verb.infinitive],
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint)].compactMap { $0 })])
        case .listening:
            guard UserDefaults.standard.bool(for: .listening) else {
                configureRandomComposition()
                viewController?.reloadData()
                return
            }
                    
            dataSource.setup([Section(items: [PlainDetailItem(text: "Listen and write".localized)].compactMap { $0 }),
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
                                                        isAudio: true)].compactMap { $0 })])
        default:
            break
        }
    }
    
    func didEndEntering() {
        guard let items = dataSource.items(of: InputItem.self) as? [InputItem],
              items.allSatisfy({ $0.isFilled }) else { return }
        
        configureRandomComposition()
        viewController?.reloadData()
    }
    
    func play(text: String, playHandler: @escaping Block, stopHandler: @escaping Block) {
        audioService.play(text: text,
                          playHandler: playHandler,
                          stopHandler: stopHandler)
    }
    
    func hint(text: String) {
        router?.show(hint: text)
    }
}

// MARK: - UITableViewDelegate

extension TestDetailPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
