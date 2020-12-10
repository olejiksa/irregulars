//
//  SliderCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SliderCell: UITableViewCell {

    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var leadingIconView: UIImageView!
    @IBOutlet private weak var trailingIconView: UIImageView!
    
    private var playbackSpeedBlock: IntBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - Private

private extension SliderCell {
    
    @IBAction func didSliderValueChange(_ sender: UISlider) {
        let roundedValue = Int(sender.value.rounded())
        sender.setValue(Float(roundedValue), animated: true)
        playbackSpeedBlock?(roundedValue)
    }
}

// MARK: - CellProtocol

extension SliderCell: CellProtocol {
    
    static var identifier: String { "\(SliderCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? SliderItem else { return }
        
        leadingIconView.image = item.leadingIcon.image
        trailingIconView.image = item.trailingIcon.image
        
        slider.maximumValue = Float(item.steps - 1)
        slider.minimumValue = 0
        slider.value = Float(item.index)
        
        playbackSpeedBlock = item.playbackSpeedBlock
    }
}
