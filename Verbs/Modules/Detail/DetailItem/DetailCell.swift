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
    @IBOutlet private weak var transcriptionLabel: UILabel?
    @IBOutlet private weak var playButton: UIButton!
    
    private var actionBlock: AudioBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        transcriptionLabel?.accessibilityElementsHidden = true
        playButton.addTarget(self, action: #selector(playButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - Private

private extension DetailCell {
    
    @objc func playButtonDidTap() {
        guard let text = titleLabel.text else { return }
        actionBlock?(text, play, stop)
    }
    
    func play() {
        playButton.set(icon: .stop)
    }
    
    func stop() {
        playButton.set(icon: .play)
        RateService().requestReviewIfAppropriate(minimumReviewWorthyActionCount: 20)
    }
}

// MARK: - CellProtocol

extension DetailCell: CellProtocol {
    
    static var identifier: String { "\(DetailCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? DetailItem else { return }
        
        titleLabel.text = item.word.value
        transcriptionLabel?.text = item.word.transcription
        actionBlock = item.actionBlock
        
        playButton.isHidden = actionBlock == nil
        
        transcriptionLabel?.isHidden = !FeatureToggle.isPaid
    }
}
