//
//  AcknowledgementsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 02.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AcknowledgementsPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    weak var viewController: AcknowledgementsViewController?
    
    override init() {
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension AcknowledgementsPresenter {
    
    func setupSections() {
        let betaTestersString: String = [.localized(.sofiiaSokolova),
                                         .localized(.artyomShumilov),
                                         .localized(.elizavetaKeplin)].joined(separator: ", ")
        
        dataSource.setup([Section(header: .localized(.sentences),
                                  items: [PlainItem(title: .localized(.sofiiaSokolova))]),
                          Section(header: .localized(.betaTesting),
                                  items: [PlainItem(title: betaTestersString)]),
                          Section(header: .localized(.translation),
                                  items: [RightDetailItem(title: "Julian Eduardo",
                                                          subtitle: Language.spanish.description),
                                          RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.italian.description),
                                          RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.japanese.description),
                                          RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.korean.description)])])
    }
}
