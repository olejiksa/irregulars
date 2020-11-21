//
//  DetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailCell: UITableViewCell {
        
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var transcriptionLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    
    private var actionBlock: ((String) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPlayButton()
    }
}

// MARK: - Private

private extension DetailCell {
    
    func setupPlayButton() {
        transcriptionLabel.isHidden = !FeatureToggle.isPaid
        playButton.isHidden = actionBlock == nil
        playButton.addTarget(self,
                             action: #selector(playButtonDidTap),
                             for: .touchUpInside)
    }
    
    @objc func playButtonDidTap() {
        guard let text = titleLabel.text else { return }
        actionBlock?(text)
    }
}

// MARK: - CellProtocol

extension DetailCell: CellProtocol {
    
    static var identifier: String { "\(DetailCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? DetailItem else { return }
        
        titleLabel.text = item.word.value
        transcriptionLabel.text = item.word.transcription
        actionBlock = item.actionBlock
    }
}
