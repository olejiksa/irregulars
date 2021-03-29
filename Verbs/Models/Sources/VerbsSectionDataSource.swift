//
//  VerbsSectionDataSource.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class VerbsSectionDataSource: SectionDataSource {
    
    var isSearchActive = false
    
    private let verbsService: VerbsServiceProtocol
    private let hasTranslation: Bool
    private let setStateBlock: Block?
    
    init(verbsService: VerbsServiceProtocol, hasTranslation: Bool, setStateBlock: Block? = nil) {
        self.verbsService = verbsService
        self.hasTranslation = hasTranslation
        self.setStateBlock = setStateBlock
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let count = !isSearchActive
            ? verbsService.groupedItems.count
            : (verbsService.searchedItems.count > 0 ? 1 : 0)
        tableView.separatorStyle = count > 0 ? .singleLine : .none
        setStateBlock?()
        return max(count, 1)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        !isSearchActive
            ? verbsService.groupedItems[safe: section]?.count ?? 0
            : verbsService.searchedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let verb = !isSearchActive
            ? verbsService.groupedItems[safe: indexPath.section]?[safe: indexPath.row]
            : verbsService.searchedItems[indexPath.row] else { return .init() }
        let item: ItemProtocol = !verbsService.shouldTranslationBeShown || !hasTranslation ?
            ListItem(verb: verb) :
            SubtitleItem(title: verb.infinitive.value, subtitle: verb.translation)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isSearchActive else { return nil }
        return verbsService.headers[safe: section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        guard !isSearchActive, !verbsService.shouldSimilarBeShown else { return nil }
        let set = Set(verbsService.headers.compactMap { $0.first?.uppercased() })
        return Array(set).sorted()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        !isSearchActive
    }
}
