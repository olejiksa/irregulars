//
//  PrintService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 07.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit
import WebKit

final class PrintService {
    
    func print(_ verbs: [Verb], hasTranslation: Bool) {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printController.printInfo = printInfo

        let htmlString = buildHTMLTable(verbs, hasTranslation: hasTranslation)
        
        printController.printFormatter = UIMarkupTextPrintFormatter(markupText: htmlString)
        printController.present(animated: true, completionHandler: nil)
    }
}

// MARK: - Private

private extension PrintService {
    
    func buildHTMLTable(_ verbs: [Verb], hasTranslation: Bool) -> String {
        let color = AccentColor.current.color
        
        var string = "<!DOCTYPE html>"
        
        string += "<html>"
        string += "<head>"
        string += "<title>Printing</title>"
        string += """
<style type="text/css">
table { page-break-inside:auto }
tr    { page-break-inside:avoid; page-break-after:auto }

.styled-table {
    font-size: 0.9em;
    font-family: sans-serif;
    width: 100%;
    border-collapse: separate;
    border-spacing: 2px;
    border-color: \(color.rgbaString);
}

.styled-table thead tr {
    background-color: \(color.rgbaString);
    color: #ffffff;
    text-align: left;
}

.styled-table th,
.styled-table td {
    padding: 4px 5px;
}

.styled-table tbody tr {
    border-color: \(color.rgbaString);
}

.styled-table tbody tr:nth-of-type(even) {
    background-color: #f3f3f3;
}

.styled-table tbody tr:last-of-type {
    border-color: \(color.rgbaString);
}
</style>
"""
        string += "</head>"
        string += "<body>"
        string += "<table class=\"styled-table\">"
        string += "<thead>"
        string += "<tr>"
        string += "<th>\(String.localized(.infinitive))</th>"
        string += "<th>\(String.localized(.pastSimple))</th>"
        string += "<th>\(String.localized(.pastParticiple))</th>"
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
        string += "</body>"
        string += "</html>"
        return string
    }
}

private extension UIColor {
    
    var coreColor: CIColor {
        .init(color: self)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreColor = self.coreColor
        return (coreColor.red, coreColor.green, coreColor.blue, coreColor.alpha)
    }
    
    var rgbaString: String {
        "rgba(\(coreColor.red * 255),\(coreColor.green * 255),\(coreColor.blue * 255),\(coreColor.alpha * 255))"
    }
}
