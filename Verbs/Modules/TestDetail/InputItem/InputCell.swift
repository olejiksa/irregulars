//
//  InputCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class InputCell: UITableViewCell {
    
    @IBOutlet private weak var textField: UITextField!
    
    private var expectedValue: String?
    private var successActionBlock: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.becomeFirstResponder()
        textField.placeholder = "Enter here".localized
        textField.delegate = self
        
        selectionStyle = .none
    }
}

// MARK: - Private

private extension InputCell {
    
    
}

// MARK: - CellProtocol

extension InputCell: CellProtocol {
    
    static var identifier: String { "\(InputCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? InputItem else { return }
        
        textField.text = ""
        
        expectedValue = item.word.value
        successActionBlock = item.successActionBlock
    }
}

// MARK: - UITextFieldDelegate

extension InputCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField.text?.appending(string) == expectedValue {
            successActionBlock?()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
