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
    private var hint: String?
    
    init(items: [String],
         audioService: AudioService,
         verbsService: VerbsService,
         rateService: RateService) {
        self.items = items
        self.audioService = audioService
        self.verbsService = verbsService
        self.rateService = rateService
        super.init()
        setupSections()
    }
    
    @objc func showHint() {
        guard let hint = hint else { return }
        router?.show(hint: hint)
    }
}

// MARK: - Private

private extension TestDetailPresenter {
    
    func setupSections() {
        configureRandomComposition()
    }
    
    func configureRandomComposition() {
        guard !items.isEmpty else {
            rateService.requestReviewIfAppropriate()
            router?.goBack()
            return
        }
        
        guard let verb = verbsService.verb(of: items.randomElement()),
              let index = items.firstIndex(of: verb.infinitive.value),
              let simplePast = verb.simplePast.first,
              let pastParticiple = verb.pastParticiple?.first
        else { return }
        
        items.remove(at: index)
        
        let randomVerbForm = VerbForm.allCases.randomElement() ?? .infinitive
        
        switch randomVerbForm {
        case .infinitive:
            hint = verb.infinitive.value
            dataSource.setup([Section(header: randomVerbForm.rawValue,
                                      items: [InputItem(word: verb.infinitive,
                                                        successActionBlock: didEndEntering)].compactMap { $0 }),
                              Section(header: "Simple Past",
                                      items: [PlainDetailItem(word: simplePast)].compactMap { $0 }),
                              Section(header: "Past Participle",
                                      items: [PlainDetailItem(word: pastParticiple)].compactMap { $0 })])
        case .simplePast:
            hint = simplePast.value
            dataSource.setup([Section(header: "Infinitive",
                                      items: [PlainDetailItem(word: verb.infinitive)].compactMap { $0 }),
                              Section(header: randomVerbForm.rawValue,
                                      items: [InputItem(word: simplePast,
                                                        successActionBlock: didEndEntering)].compactMap { $0 }),
                              Section(header: "Past Participle",
                                      items: [PlainDetailItem(word: pastParticiple)].compactMap { $0 })])
        case .pastParticiple:
            hint = pastParticiple.value
            dataSource.setup([Section(header: "Infinitive",
                                      items: [PlainDetailItem(word: verb.infinitive)].compactMap { $0 }),
                              Section(header: "Simple Past",
                                      items: [PlainDetailItem(word: simplePast)].compactMap { $0 }),
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
