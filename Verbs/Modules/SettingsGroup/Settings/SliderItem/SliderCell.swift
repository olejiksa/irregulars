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
    
    private weak var item: SliderItem?
    
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
        item?.index = roundedValue
        item?.playbackSpeedBlock(roundedValue)
    }
}

// MARK: - CellProtocol

extension SliderCell: CellProtocol {
    
    static var identifier: String { "\(SliderCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? SliderItem else { return }
        
        self.item = item
        
        leadingIconView.image = item.leadingIcon.image
        leadingIconView.accessibilityLabel = item.leadingAccessibilityText
        
        trailingIconView.image = item.trailingIcon.image
        trailingIconView.accessibilityLabel = item.trailingAccessibilityText
        
        slider.maximumValue = Float(item.steps - 1)
        slider.minimumValue = 0
        slider.value = Float(item.index)
        slider.isEnabled = item.isEnabled
        
        isUserInteractionEnabled = item.isEnabled
    }
}
