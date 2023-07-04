//
//  OnboardingViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    
    @Published private(set) var items: [OnboardingItem] = []
    @Published var selection = 0
    
    var isLast: Bool {
        selection == items.count - 1
    }
    
    private let analyticsService = AnalyticsService()
    
    init() {
        items = [
            .init(id: 0,
                  emoji: "🤗",
                  title: "onboarding.hello".localized,
                  content: "onboarding.hello.description".localized),
            .init(id: 1,
                  emoji: "🤔",
                  title: "onboarding.why".localized,
                  content: "onboarding.why.description".localized),
            .init(id: 2,
                  emoji: "🧐",
                  title: "onboarding.imagine".localized,
                  content: "onboarding.imagine.description".localized),
            .init(id: 3,
                  emoji: "📖",
                  title: "onboarding.three_forms".localized,
                  content: "onboarding.three_forms.description".localized),
            .init(id: 4,
                  emoji: "📒",
                  title: "onboarding.regular_verbs".localized,
                  content: "onboarding.regular_verbs.description".localized),
            .init(id: 5,
                  emoji: "📔",
                  title: "onboarding.irregular_verbs".localized,
                  content: "onboarding.irregular_verbs.description".localized),
            .init(id: 6,
                  emoji: "🥳",
                  title: "onboarding.are_you_ready_for_it".localized,
                  content: "onboarding.are_you_ready_for_it.description".localized)
        ]
        
        analyticsService.send(event: .onboardingStarted)
    }
    
    func close() {
        analyticsService.send(event: .onboardingClosed)
    }
    
    func `continue`() {
        analyticsService.send(event: .onboardingContinueTapped)
    }
    
    func finish() {
        analyticsService.send(event: .onboardingFinished)
    }
}
