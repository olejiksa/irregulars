//
//  SentencePresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 06.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SentencePresenter: NSObject {
    
    let dataSource = SectionDataSource()
    
    override init() {
        super.init()
        setupSections()
    }
    
    @objc func showHint() {
        
    }
}

// MARK: - Private

private extension SentencePresenter {
    
    func setupSections() {
        dataSource.setup([Section(header: "Sentence".localized,
                                  items: [PlainItem(title: "He can't ___ still")]),
                          Section(header: "Choose a word from offered".localized,
                                  items: [PlainItem(title: "knelt", hasDisclosureIndicator: true),
                                          PlainItem(title: "sit", hasDisclosureIndicator: true),
                                          PlainItem(title: "lose", hasDisclosureIndicator: true),
                                          PlainItem(title: "shed", hasDisclosureIndicator: true)])])
    }
}

// MARK: - UITableViewDelegate

extension SentencePresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
