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
    
    private var action: IntBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}

// MARK: - Private

private extension TimePickerCell {
    
    @IBAction func didValueChange(_ sender: UIDatePicker) {
        let components = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: sender.date)
        guard let hour = components.hour, let minute = components.minute else { return }
        let value = hour * 60 + minute
        action?(value)
    }
}

// MARK: - CellProtocol

extension TimePickerCell: CellProtocol {
    
    static var identifier: String { "\(TimePickerCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? TimePickerItem else { return }
        
        let hour = item.value / 60
        let minute = item.value % 60
        let components = DateComponents(hour: hour, minute: minute)
        guard let date = Calendar.autoupdatingCurrent.date(from: components) else { return }
        timePicker.date = date
        
        titleLabel?.text = item.title
        
        isUserInteractionEnabled = item.isEnabled
        titleLabel?.isEnabled = item.isEnabled
        
        action = item.action
    }
}
