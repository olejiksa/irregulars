//
//  OnboardingItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

struct OnboardingItem: Identifiable, Equatable {
    
    let id: Int
    let emoji: String
    let title: String
    let content: String
}
