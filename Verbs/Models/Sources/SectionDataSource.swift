//
//  SectionDataSource.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

class SectionDataSource: NSObject {
    
    private var sectionArray = SectionArray()
    
    func setup(_ array: [TableViewSection]) {
        sectionArray.setup(array)
    }
    
    func item(at indexPath: IndexPath) -> ItemProtocol? {
        sectionArray.item(indexPath)
    }
    
    func items<T>(of type: T.Type) -> [ItemProtocol] where T: ItemProtocol {
        sectionArray.items(of: type)
    }
}

// MARK: - UITableViewDataSource

extension SectionDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionArray.count(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = sectionArray.item(indexPath) else { return .init(frame: .zero) }
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionArray.header(section)
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        sectionArray.footer(section)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
}
