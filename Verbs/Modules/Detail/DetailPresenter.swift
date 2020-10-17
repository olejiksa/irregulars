//
//  DetailPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailPresenter: NSObject {
    
    private let audioService: AudioService
    private let languageService: LanguageService
    private let verb: Verb
    private var sections = SectionArray()
    
    var title: String { verb.infinitive.value }
    
    init(audioService: AudioService,
         languageService: LanguageService,
         verb: Verb) {
        self.audioService = audioService
        self.languageService = languageService
        self.verb = verb
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension DetailPresenter {
    
    func setupSections() {
        let verbItems = [DetailItem(word: verb.infinitive, actionBlock: play),
                         DetailItem(word: verb.simplePast, actionBlock: play),
                         DetailItem(word: verb.pastParticiple, actionBlock: play)]
            .compactMap { $0 }
        let translationItems = [TranslationItem(text: verb.translation)]
            .filter { _ in languageService.hasTranslation }
        sections.setup([Section(header: "Infinitive, Simple Past, Past Participle", items: verbItems),
                        Section(header: "Translation".localized, items: translationItems)])
    }
    
    func play(text: String) {
        audioService.play(text: text)
    }
}

// MARK: - UITableViewDataSource

extension DetailPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count(section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections.header(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections.item(indexPath)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension DetailPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
