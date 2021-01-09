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
        let betaTestersString: String = [.localized(.sofiaSokolova),
                                         .localized(.artemShumilov),
                                         .localized(.elizabethKeplin)].joined(separator: ", ")
        
        dataSource.setup([Section(header: .localized(.sentences),
                                  items: [PlainItem(title: .localized(.sofiaSokolova))]),
                          Section(header: .localized(.betaTesting),
                                  items: [PlainItem(title: betaTestersString)]),
                          Section(header: .localized(.translation),
                                  items: [RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.french.description),
                                          RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.german.description),
                                          RightDetailItem(title: "Julian Eduardo Couoh Pablo",
                                                          subtitle: Language.spanish.description),
                                          RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.japanese.description),
                                          RightDetailItem(title: .localized(.tatianaPerfilieva),
                                                          subtitle: Language.korean.description),
                                          RightDetailItem(title: "To Be Clarified",
                                                          subtitle: Language.chinese.description)])])
    }
}
