//
//  ProgressCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class ProgressCell: UITableViewCell {

    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

extension ProgressCell: CellProtocol {
    
    static var identifier: String { "\(ProgressCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? ProgressItem else { return }
        
        let maximum = String(format: "Of".localized, item.maximum)
        captionLabel.text = "\(item.value) \(maximum)"
        progressView.progress = Float(item.value) / Float(item.maximum)
    }
}
