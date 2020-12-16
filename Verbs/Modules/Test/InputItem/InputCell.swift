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
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var hintButton: UIButton!
    
    private weak var item: InputItem?
    private var expectedValues: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.placeholder = "Enter here".localized
        textField.delegate = self
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        item = nil
        expectedValues = nil
        isUserInteractionEnabled = true
        textField.isUserInteractionEnabled = true
        hintButton.isHidden = false
        textField.text = nil
        textField.attributedText = nil
    }
}

// MARK: - Private

private extension InputCell {
    
    @IBAction func didHintTap() {
        guard let text = expectedValues?.first else { return }
        item?.hintActionBlock(text)
    }
    
    @IBAction func didPlayTap() {
        guard let text = expectedValues?.first else { return }
        item?.playActionBlock?(text, play, stop)
    }
    
    func applyValidation(_ text: String) {
        if expectedValues?.contains(where: { $0.lowercased() == text.lowercased() }) == false {
            let element = expectedValues?.randomElement() ?? ""
            let rawAttributedText = element + " " + text + " "
            let attributeString = NSMutableAttributedString(string: rawAttributedText)
            attributeString.addAttribute(.strikethroughStyle,
                                         value: 2,
                                         range: NSRange(location: element.count + 1, length: text.count))
            textField.attributedText = attributeString
        } else {
            item?.isValid = true
        }
    }
}

// MARK: - CellProtocol

extension InputCell: CellProtocol {
    
    static var identifier: String { "\(InputCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? InputItem else { return }
        
        self.item = item
        
        textField.tag = item.tag
        textField.returnKeyType = item.returnKeyType
        expectedValues = item.words.map { $0.value }
        playButton.isHidden = !item.isAudio
    }
}

// MARK: - Private

private extension InputCell {
    
    func play() {
        playButton.setImage(SystemIcon.stop.image, for: .normal)
    }
    
    func stop() {
        playButton.setImage(SystemIcon.play.image, for: .normal)
    }
}

// MARK: - UITextFieldDelegate

extension InputCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        applyValidation(text)
        
        item?.isFilled = true
        item?.successActionBlock()
        
        textField.isUserInteractionEnabled = false
        hintButton.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let hostView = contentView.superview?.superview
        if let nextTextField = hostView?.viewWithTag(textField.tag + 1) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
