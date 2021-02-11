//
//  TimePickerCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TimePickerCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timePicker: UIDatePicker!
    
    private weak var item: TimePickerItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - CellProtocol

extension TimePickerCell: CellProtocol {
    
    static var identifier: String { "\(TimePickerCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? TimePickerItem else { return }
        self.item = item
        
        titleLabel?.text = item.title
        
        isUserInteractionEnabled = item.isEnabled
        titleLabel?.isEnabled = item.isEnabled
    }
}
