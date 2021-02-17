//
//  StepperCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 12.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class StepperCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    
    private var action: IntBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - Private

private extension StepperCell {
    
    @IBAction func didValueChange(_ sender: UIStepper) {
        let value = Int(sender.value)
        valueLabel.text = String(value)
        action?(value)
    }
}

// MARK: - CellProtocol

extension StepperCell: CellProtocol {
    
    static var identifier: String { "\(StepperCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? StepperItem else { return }
        
        stepper.minimumValue = Double(item.minimum)
        stepper.maximumValue = Double(item.maximum)
        stepper.value = Double(item.value)
        
        valueLabel.text = String(item.value)
        titleLabel.text = item.title
        
        action = item.action
    }
}
