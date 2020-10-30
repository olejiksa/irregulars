//
//  SectionDataSource.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

final class SectionDataSource: NSObject {
    
    var sectionArray = SectionArray()
    
    func setup(_ array: [Section]) {
        sectionArray.setup(array)
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
        let item = sectionArray.item(indexPath)
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionArray.header(section)
    }
}
