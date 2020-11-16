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
    var router: DetailRouter?
    weak var viewController: TestDetailViewController?
    
    private let audioService: AudioService
    
    init(audioService: AudioService) {
        self.audioService = audioService
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension TestDetailPresenter {
    
    func setupSections() {
        dataSource.setup([Section(header: "Infinitive",
                                  items: [DetailItem(word: Word(value: "go",
                                                                transcription: ""),
                                                     actionBlock: play)].compactMap { $0 }),
                          Section(header: "Simple Past",
                                  items: [DetailItem(word: Word(value: "went",
                                                                transcription: ""),
                                                     actionBlock: play)].compactMap { $0 }),
                          Section(header: "Past Participle",
                                  items: [InputItem(word: Word(value: "gone",
                                                               transcription: ""))].compactMap { $0 })])
    }
    
    func play(text: String) {
        guard FeatureToggle.isPaid else {
            router?.goToPaywall()
            return
        }
        
        audioService.play(text: text)
    }
}

// MARK: - UITableViewDelegate

extension TestDetailPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


