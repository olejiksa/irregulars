//
//  DetailPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    var router: DetailRouter?
    weak var viewController: DetailViewController?
    
    private let audioService: AudioService
    private let languageService: LanguageService
    private let sentencesService: SentencesService
    private let verb: Verb
    
    var title: String { verb.infinitive.value }
    
    init(audioService: AudioService,
         languageService: LanguageService,
         sentencesService: SentencesService,
         verb: Verb) {
        self.audioService = audioService
        self.languageService = languageService
        self.sentencesService = sentencesService
        self.verb = verb
        super.init()
        subscribe()
        setupSections()
    }
}

// MARK: - Private

private extension DetailPresenter {
    
    func subscribe() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didPay),
                                               name: Notification.Name.reload,
                                               object: nil)
    }
    
    func setupSections() {
        let translationItems = [TranslationItem(text: verb.translation)]
            .filter { _ in languageService.hasTranslation }
        let sentences = sentencesService.items
            .filter { $0.word == verb.infinitive.value }
            .flatMap { $0.sentences }
        let examples = sentences.map { TranslationItem(text: $0) }
        dataSource.setup([Section(header: "Infinitive".localized,
                                  items: [DetailItem(word: verb.infinitive,
                                                     actionBlock: play)].compactMap { $0 }),
                          Section(header: "Simple Past".localized,
                                  items: verb.simplePast?.compactMap { DetailItem(word: $0,
                                                                                  actionBlock: play) } ?? []),
                          Section(header: "Past Participle".localized,
                                  items: verb.pastParticiple?.compactMap { DetailItem(word: $0,
                                                                                      actionBlock: play) } ?? []),
                          Section(header: "Translation".localized, items: translationItems),
                          Section(header: "Examples".localized, items: examples)])
    }
    
    func play(text: String, playHandler: @escaping Block, stopHandler: @escaping Block) {
        guard FeatureToggle.isPaid else {
            router?.goToPaywall()
            return
        }
        
        audioService.play(text: text,
                          playHandler: playHandler,
                          stopHandler: stopHandler)
    }
    
    @objc func didPay(_ notification: Notification) {
        viewController?.getPaid()
    }
}

// MARK: - UITableViewDelegate

extension DetailPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
