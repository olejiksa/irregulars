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
    
    private var item: InputItem?
    private var expectedValues: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.placeholder = "Enter here".localized
        textField.delegate = self
        
        selectionStyle = .none
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
}

// MARK: - CellProtocol

extension InputCell: CellProtocol {
    
    static var identifier: String { "\(InputCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? InputItem else { return }
        self.item = item
        
        textField.text = ""
        
        expectedValues = item.words.map { $0.value }
        
        playButton.isHidden = !item.isAudio
    }
}

// MARK: - Private

private extension InputCell {
    
    func play() {
        playButton.setImage(UIImage(systemName: "stop.circle"), for: .normal)
    }
    
    func stop() {
        playButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
    }
}

// MARK: - UITextFieldDelegate

extension InputCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text?.appending(string) else { return true }
        if expectedValues?.contains(where: { $0.lowercased() == text.lowercased() }) == true {
            item?.isFilled = true
            item?.successActionBlock()
        } else {
            item?.isFilled = false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
