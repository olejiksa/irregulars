//
//  HapticFeedback.swift
//  Verbs
//
//  Created by Oleg Samoylov on 14.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

enum HapticFeedback {
    
    case selection
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
}
