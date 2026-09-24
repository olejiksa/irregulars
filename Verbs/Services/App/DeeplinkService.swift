//
//  DeeplinkService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

/// Turns the ways the system can open the app — a verbs:// link, a Spotlight result,
/// a home screen shortcut — into navigation state.
@MainActor
final class DeeplinkService {
    
    private let router: AppRouter
    private let verbsService = VerbsService()
    
    init(router: AppRouter) {
        self.router = router
    }
    
    func handle(_ host: String) {
        guard let verb = verbsService.items.first(where: { host == $0.infinitive.value }) else { return }
        
        router.show(verb)
    }
    
    func search(text: String) {
        router.search(text)
    }
    
    func favorites() {
        router.showFavorites()
    }
    
    func tests() {
        router.showTests()
    }
    
    func statistics() {
        router.showStatistics()
    }
}
