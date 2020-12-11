//
//  TestPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    var router: TestRouter?
    weak var viewController: TestViewController?
    
    private var items: [String]
    private let audioService: AudioService
    private let verbsService: VerbsService
    private let favoritesService: FavoritesService
    private let itemsFactory: TestItemsFactory
    private let test: Test
    
    private var currentTestKind: Test.Kind?
    
    init(audioService: AudioService,
         verbsService: VerbsService,
         favoritesService: FavoritesService,
         itemsFactory: TestItemsFactory,
         test: Test) {
        self.verbsService = verbsService
        self.favoritesService = favoritesService
        self.items = UserDefaults.standard.bool(for: .favoritesOnly)
            ? favoritesService.items.map { $0.infinitive.value }
            : verbsService.items.map { $0.infinitive.value }
        self.audioService = audioService
        self.itemsFactory = itemsFactory
        self.test = test
        super.init()
        
        loadSettings()
        setupSections()
    }
}

// MARK: - Private

private extension TestPresenter {
    
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
              let currentTestKind = test == .basic ?
                Test.basic.kinds.randomElement() :
                Test.advanced.kinds.randomElement()
        else {
            configureRandomComposition()
            viewController?.reloadData()
            return
        }
        
        items.remove(at: index)
        
        let sections = itemsFactory.build(with: currentTestKind,
                                          verb: verb,
                                          hint: hint, didEndEntering: didEndEntering,
                                          play: play)
        
        guard !sections.isEmpty else {
            configureRandomComposition()
            viewController?.reloadData()
            return
        }
        
        dataSource.setup(sections)
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

extension TestPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
