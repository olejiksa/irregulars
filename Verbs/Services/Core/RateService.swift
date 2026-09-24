//
//  RateService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import StoreKit

@MainActor
final class RateService {
    
    func requestReviewIfAppropriate(minimumReviewWorthyActionCount: Int) {
        var actionCount = UserDefaults.shared.integer(for: .reviewWorthyActionCount)
        actionCount += 1
        
        UserDefaults.shared.set(actionCount, for: .reviewWorthyActionCount)
        
        guard actionCount >= minimumReviewWorthyActionCount else { return }
        
        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = UserDefaults.shared.string(for: .lastReviewRequestAppVersion)
        
        guard lastVersion == nil || lastVersion != currentVersion else { return }
        
        requestReview()
        
        UserDefaults.shared.set(0, for: .reviewWorthyActionCount)
        UserDefaults.shared.set(currentVersion, for: .lastReviewRequestAppVersion)
    }
}

// MARK: - Private

private extension RateService {
    
    func requestReview() {
        let scenes = UIApplication.shared.connectedScenes
        let isForegroundScene: (UIScene) -> Bool = { $0.activationState == .foregroundActive }
        guard let scene = scenes.first(where: isForegroundScene) as? UIWindowScene else { return }
        
        Task { @MainActor in
            AppStore.requestReview(in: scene)
        }
    }
}
