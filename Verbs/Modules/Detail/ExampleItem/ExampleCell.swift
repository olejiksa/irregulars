//
//  ExampleCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ExampleCell: UITableViewCell {
    
    @IBOutlet private weak var contentLabel: UILabel!
}

// MARK: - Private

private extension ExampleCell {
    
    func attributedString(_ sentence: String, using verb: Verb) -> NSAttributedString? {
        if let range = contains([verb.infinitive], in: sentence) ??
            contains(verb.simplePast, in: sentence) ??
            contains(verb.pastParticiple, in: sentence) {
            let attributedString = NSMutableAttributedString(string: sentence)
            let boldSystemFont = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
            let scaledFont = UIFontMetrics.default.scaledFont(for: boldSystemFont)
            attributedString.addAttribute(.font, value: scaledFont, range: range)
            return attributedString
        } else {
            print(sentence)
            return nil
        }
    }
    
    func contains(_ words: [Word]?, in sentence: String) -> NSRange? {
        guard let words = words else { return nil }
        
        for word in words {
            let pattern = "\\b\(word.value)\\b"
            guard let range = sentence.range(of: pattern,
                                             options: [.regularExpression,
                                                       .caseInsensitive]) else { continue }
            return .init(range, in: sentence)
        }
        
        return nil
    }
}

// MARK: - CellProtocol

extension ExampleCell: CellProtocol {
    
    static var identifier: String { "\(ExampleCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? ExampleItem else { return }
        
        contentLabel.attributedText = attributedString(item.sentence, using: item.verb)
    }
}
