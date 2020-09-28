//
//  DetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailCell: UITableViewCell {
        
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
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
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        let largeImage = UIImage(systemName: "play.circle", withConfiguration: largeConfig)
        playButton.setImage(largeImage, for: .normal)
        playButton.addTarget(self, action: #selector(playButtonDidTap), for: .touchUpInside)
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
        
        captionLabel.text = item.caption
        titleLabel.text = item.title
        actionBlock = item.actionBlock
    }
}
