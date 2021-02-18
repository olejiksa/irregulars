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
    private var scrollingBlock: CellBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func didEditingBegin(_ sender: UIDatePicker) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(autoScroll),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
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
    
    @objc func autoScroll() {
        scrollingBlock?(self)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - CellProtocol

extension TimePickerCell: CellProtocol {
    
    static var identifier: String { "\(TimePickerCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? TimePickerItem else { return }
        
        if let date = CalendarService().date(from: item.value) {
            timePicker.date = date
        }
        
        titleLabel?.text = item.title
        
        isUserInteractionEnabled = item.isEnabled
        titleLabel?.isEnabled = item.isEnabled
        
        action = item.action
        scrollingBlock = item.scrollingBlock
    }
}
