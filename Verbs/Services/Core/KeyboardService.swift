//
//  KeyboardService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class KeyboardService {
    
    private weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    private weak var view: UIView?
    
    init(keyboardHeightLayoutConstraint: NSLayoutConstraint?, view: UIView?) {
        self.keyboardHeightLayoutConstraint = keyboardHeightLayoutConstraint
        self.view = view
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjust),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjust),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

// MARK: - Private

private extension KeyboardService {
    
    @objc func adjust(notification: Notification) {
        guard let view = view,
              let userInfo = notification.userInfo,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        let convertedFrame = view.convert(endFrame, from: nil)
        let endFrameY = endFrame.origin.y
        
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        let screenHeight = view.window?.windowScene?.screen.bounds.size.height ?? .greatestFiniteMagnitude
        
        if endFrameY >= screenHeight {
            keyboardHeightLayoutConstraint?.constant = 0
        } else {
            let newHeight = view.bounds.size.height - convertedFrame.origin.y
            keyboardHeightLayoutConstraint?.constant = -newHeight
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: animationCurve,
                       animations: { view.layoutIfNeeded() },
                       completion: nil)
    }
}
