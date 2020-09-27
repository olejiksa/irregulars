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
                                               selector: #selector(keyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Private

private extension KeyboardService {
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve = UIView.AnimationOptions(rawValue: animationCurveRaw)
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            keyboardHeightLayoutConstraint?.constant = 0
        } else {
            keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0
        }
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: animationCurve,
                       animations: { self.view?.layoutIfNeeded() },
                       completion: nil)
    }
}
