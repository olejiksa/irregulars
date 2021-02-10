//
//  PickerCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PickerCell: UITableViewCell {
    
    private let picker = UIPickerView()
    private weak var item: PickerItem?
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
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(didDoneTap))
        doneButton.tintColor = AccentColor.current.color
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
                                           target: self,
                                           action: #selector(didCancelTap))
        cancelButton.tintColor = AccentColor.current.color
        toolbar.items = [cancelButton, spaceButton, doneButton]
        return toolbar
    }
}

// MARK: - Private

private extension PickerCell {
    
    @objc func didDoneTap() {
        guard let subtitle = selectedValue else { return }
        self.item?.subtitle = subtitle
        guard let item = item else { return }
        self.item?.actionBlock?(item)
        resignFirstResponder()
    }

    @objc func didCancelTap() {
        selectedValue = item?.subtitle
        let index = item?.options.firstIndex { $0 == selectedValue } ?? 0
        picker.selectRow(index, inComponent: 0, animated: true)
        resignFirstResponder()
    }
}

// MARK: - CellProtocol

extension PickerCell: CellProtocol {
    
    static var identifier: String { "\(PickerCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? PickerItem else { return }
        self.item = item
        self.selectedValue = item.subtitle
        
        textLabel?.text = item.title
        detailTextLabel?.text = item.subtitle
        accessoryType = item.hasDisclosureIndicator ? .disclosureIndicator : .none
        
        let index = item.options.firstIndex { $0 == selectedValue } ?? 0
        picker.selectRow(index, inComponent: 0, animated: true)
        
        isUserInteractionEnabled = item.isEnabled
        textLabel?.isEnabled = item.isEnabled
        detailTextLabel?.isEnabled = item.isEnabled
    }
}

// MARK: - UIPickerViewDataSource

extension PickerCell: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        item?.options.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        item?.options[row]
    }
}

// MARK: - UIPickerViewDelegate

extension PickerCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard let subtitle = item?.options[row] else { return }
        selectedValue = subtitle
    }
}
