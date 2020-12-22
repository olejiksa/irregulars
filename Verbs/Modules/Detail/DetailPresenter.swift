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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willReloadData),
                                               name: Notification.Name.favorites,
                                               object: nil)
    }
    
    func setupSections() {
        let translationItems = [TranslationItem(text: verb.translation)]
            .filter { _ in languageService.hasTranslation }
        let sentences = sentencesService.items
            .filter { $0.word == verb.infinitive.value }
            .flatMap { $0.sentences }
        let examples = sentences.map { ExampleItem(sentence: $0, verb: verb) }
        dataSource.setup([Section(header: "infinitive".localized,
                                  items: [DetailItem(word: verb.infinitive,
                                                     actionBlock: play)].compactMap { $0 }),
                          Section(header: "simple_past".localized,
                                  items: verb.simplePast?.compactMap { DetailItem(word: $0,
                                                                                  actionBlock: play) } ?? []),
                          Section(header: "past_participle".localized,
                                  items: verb.pastParticiple?.compactMap { DetailItem(word: $0,
                                                                                      actionBlock: play) } ?? []),
                          Section(header: "translation".localized, items: translationItems),
                          Section(header: "examples".localized, items: examples)])
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
    
    @objc func willReloadData(_ notification: Notification) {
        viewController?.updateFavoriteButton()
    }
}

// MARK: - UITableViewDelegate

extension DetailPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        dataSource.item(at: indexPath) is ExampleItem
    }
    
    func tableView(_ tableView: UITableView,
                   canPerformAction action: Selector,
                   forRowAt indexPath: IndexPath,
                   withSender sender: Any?) -> Bool {
        action == #selector(MenuAction.copy(_:))
    }
    
    func tableView(_ tableView: UITableView,
                   performAction action: Selector,
                   forRowAt indexPath: IndexPath,
                   withSender sender: Any?) {
        let item = dataSource.item(at: indexPath) as? ExampleItem
        UIPasteboard.general.string = item?.sentence
    }
}
