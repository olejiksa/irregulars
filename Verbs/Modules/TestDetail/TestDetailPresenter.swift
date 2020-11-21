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
    
    private let items: [String]
    private let audioService: AudioService
    private let verbsService: VerbsService
    
    init(items: [String], audioService: AudioService, verbsService: VerbsService) {
        self.items = items
        self.audioService = audioService
        self.verbsService = verbsService
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
        guard let verb = verbsService.verb(of: items.randomElement()),
              let simplePast = verb.simplePast.first,
              let pastParticiple = verb.pastParticiple?.first
        else { return }
        
        let randomVerbForm = VerbForm.allCases.randomElement() ?? .infinitive
        
        switch randomVerbForm {
        case .infinitive:
            dataSource.setup([Section(header: randomVerbForm.rawValue,
                                      items: [InputItem(word: verb.infinitive,
                                                        successActionBlock: didEndEntering)].compactMap { $0 }),
                              Section(header: "Simple Past",
                                      items: [DetailItem(word: simplePast)].compactMap { $0 }),
                              Section(header: "Past Participle",
                                      items: [DetailItem(word: pastParticiple)].compactMap { $0 })])
        case .simplePast:
            dataSource.setup([Section(header: "Infinitive",
                                      items: [DetailItem(word: verb.infinitive)].compactMap { $0 }),
                              Section(header: randomVerbForm.rawValue,
                                      items: [InputItem(word: simplePast,
                                                        successActionBlock: didEndEntering)].compactMap { $0 }),
                              Section(header: "Past Participle",
                                      items: [DetailItem(word: pastParticiple)].compactMap { $0 })])
        case .pastParticiple:
            dataSource.setup([Section(header: "Infinitive",
                                      items: [DetailItem(word: verb.infinitive)].compactMap { $0 }),
                              Section(header: "Simple Past",
                                      items: [DetailItem(word: simplePast)].compactMap { $0 }),
                              Section(header: randomVerbForm.rawValue,
                                      items: [InputItem(word: pastParticiple,
                                                        successActionBlock: didEndEntering)].compactMap { $0 })])
        }
    }
    
    func didEndEntering() {
        configureRandomComposition()
        viewController?.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension TestDetailPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
