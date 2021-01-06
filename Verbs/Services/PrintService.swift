//
//  PrintService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 07.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PrintService {
    
    func print(_ verbs: [Verb], hasTranslation: Bool) {
        let printController = UIPrintInteractionController.shared

        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        
        printController.printInfo = printInfo

        let htmlString = buildHTMLTable(verbs, hasTranslation: hasTranslation)
        
        let formatter = UIMarkupTextPrintFormatter(markupText: htmlString)
        formatter.perPageContentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
        printController.printFormatter = formatter
        
        printController.present(animated: true, completionHandler: nil)
    }
}

// MARK: - Private

private extension PrintService {
    
    func buildHTMLTable(_ verbs: [Verb], hasTranslation: Bool) -> String {
        var string = "<table>"
        string += "<thead>"
        string += "<tr>"
        string += "<th>Infinitive</th>"
        string += "<th>Past Simple</th>"
        string += "<th>Past Participle</th>"
        if hasTranslation { string += "<th>\(String.localized(.translation))</th>" }
        string += "</tr>"
        string += "</thead>"
        string += "</tbody>"
        
        for verb in verbs {
            string += "<tr>"
            string += "<td>\(verb.infinitive.value)</td>"
            string += "<td>\(verb.simplePast?.map(\.value).joined(separator: ", ") ?? "—")</td>"
            string += "<td>\(verb.pastParticiple?.map(\.value).joined(separator: ", ") ?? "—")</td>"
            if hasTranslation { string += "<td>\(verb.translation)</td>" }
            string += "</tr>"
        }
        
        string += "</tbody>"
        string += "</table>"
        return string
    }
}
