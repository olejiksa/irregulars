//
//  RateService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import StoreKit

final class RateService {
    
    func requestReviewIfAppropriate() {
        let scenes = UIApplication.shared.connectedScenes
        let isForegroundScene: (UIScene) -> Bool = { $0.activationState == .foregroundActive }
        guard let scene = scenes.first(where: isForegroundScene) as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
}
