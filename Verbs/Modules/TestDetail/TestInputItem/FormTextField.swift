//
//  FormTextField.swift
//  Verbs
//
//  Created by Oleg Samoylov on 17.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

@IBDesignable
final class FormTextField: UITextField {

    @IBInspectable var heightInset: CGFloat = 0
    @IBInspectable var widthInset: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.insetBy(dx: widthInset, dy: heightInset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }
}
