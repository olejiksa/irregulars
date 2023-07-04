//
//  AnalyticsService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/23/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import YandexMobileMetrica

struct AnalyticsService {
    
    enum Event: String {
        case onboardingStarted
        case onboardingClosed
        case onboardingContinueTapped
        case onboardingFinished
        
        case appOpened
        case accentColorOpened
        case voiceOpened
        case notificationsOpened
        case acknowledgmentsOpened
        
        case paywallOpened
        case paywallBuyTapped
    }
    
    func start() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: Constants.appMetricaAPIKey) else { return }
        YMMYandexMetrica.activate(with: configuration)
        AnalyticsService().send(event: .appOpened)
    }
    
    func send(event: Event) {
        YMMYandexMetrica.reportEvent(event.rawValue)
    }
}
