//
//  HapticService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 14.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit
import CoreHaptics

@MainActor
final class HapticService {
    
    func generateHapticFeedback(for hapticFeedback: HapticFeedback) {
        switch hapticFeedback {
        case .selection:
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        case .impact(let feedbackStyle):
            let feedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
            feedbackGenerator.impactOccurred()
        case .notification(let feedbackType):
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(feedbackType)
        }
    }
}
