//
//  RightDetailCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 23.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RightDetailCell: UITableViewCell {
    
    private let picker = UIPickerView()
    private var item: RightDetailItem?
    private var selectedValue: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    
    override var canBecomeFirstResponder: Bool { true }
    override var canResignFirstResponder: Bool { true }
    
    override var inputView: UIView? { picker }
    
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done".localized,
                                         style: .done,
                                         target: self,
                                         action: #selector(doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel".localized,
                                           style: .plain,
                                           target: self,
                                           action: #selector(cancelTapped))
        toolbar.items = [cancelButton, spaceButton, doneButton]
        return toolbar
    }
}

// MARK: - Private

private extension RightDetailCell {
    
    @objc func doneTapped() {
        guard let subtitle = selectedValue else { return }
        self.item?.subtitle = subtitle
        guard let item = item else { return }
        self.item?.actionBlock?(item)
        resignFirstResponder()
    }

    @objc func cancelTapped() {
        selectedValue = item?.subtitle
        let index = item?.subitems?.firstIndex { $0 == selectedValue } ?? 0
        picker.selectRow(index, inComponent: 0, animated: true)
        resignFirstResponder()
    }
}

// MARK: - CellProtocol

extension RightDetailCell: CellProtocol {
    
    static var identifier: String { "\(RightDetailCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? RightDetailItem else { return }
        self.item = item
        self.selectedValue = item.subtitle
        
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
        accessoryType = item.actionBlock != nil ? .disclosureIndicator : .none
        
        let index = item.subitems?.firstIndex { $0 == selectedValue } ?? 0
        picker.selectRow(index, inComponent: 0, animated: true)
        
        isUserInteractionEnabled = item.isEnabled
        textLabel?.isEnabled = item.isEnabled
        detailTextLabel?.isEnabled = item.isEnabled
    }
}

// MARK: - UIPickerViewDataSource

extension RightDetailCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        item?.subitems?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        item?.subitems?[row]
    }
}

// MARK: - UIPickerViewDelegate

extension RightDetailCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard let subtitle = item?.subitems?[row] else { return }
        selectedValue = subtitle
    }
}
