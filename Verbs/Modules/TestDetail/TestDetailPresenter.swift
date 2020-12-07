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
    private let rateService: RateService
    private var currentTestKind: TestKind?
    
    init(audioService: AudioService,
         verbsService: VerbsService,
         rateService: RateService) {
        self.items = verbsService.items.map { $0.infinitive.value }
        self.audioService = audioService
        self.verbsService = verbsService
        self.rateService = rateService
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension TestDetailPresenter {
    
    func setupSections() {
        configureRandomComposition()
    }
    
    func configureRandomComposition() {
        guard !items.isEmpty else {
            router?.goBack()
            return
        }
        
        guard let verb = verbsService.verb(of: items.randomElement()),
              let index = items.firstIndex(of: verb.infinitive.value),
              let simplePast = verb.simplePast.first,
              let pastParticiple = verb.pastParticiple?.first
        else { return }
        
        items.remove(at: index)
        
        currentTestKind = TestKind.allCases.randomElement()
        
        switch currentTestKind {
        case .translation:
            dataSource.setup([Section(header: "Translation".localized,
                                      items: [PlainItem(title: verb.infinitive.value.localized)]),
                              Section(header: "Infinitive",
                                      items: [InputItem(word: verb.infinitive,
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint)].compactMap { $0 }),
                              Section(header: "Simple Past",
                                      items: [InputItem(word: simplePast,
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint)].compactMap { $0 }),
                              Section(header: "Past Participle",
                                      items: [InputItem(word: pastParticiple,
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint)].compactMap { $0 })])
        case .retranslation:
            dataSource.setup([Section(header: "Translation".localized,
                                      items: [PlainItem(title: verb.infinitive.value.localized)].compactMap { $0 }),
                              Section(header: "Infinitive",
                                      items: [InputItem(word: verb.infinitive,
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint)].compactMap { $0 })])
        case .listening:
            dataSource.setup([Section(header: "Infinitive",
                                      items: [InputItem(word: verb.infinitive,
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint,
                                                        isAudio: true)].compactMap { $0 }),
                              Section(header: "Simple Past",
                                      items: [InputItem(word: simplePast,
                                                        playActionBlock: play,
                                                        successActionBlock: didEndEntering,
                                                        hintActionBlock: hint,
                                                        isAudio: true)].compactMap { $0 }),
                              Section(header: "Past Participle",
                                      items: [InputItem(word: pastParticiple,
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
