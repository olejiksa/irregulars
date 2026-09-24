//
//  DetailViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation

@MainActor
final class DetailViewModel: ObservableObject {
    
    let verb: Verb
    let sentences: [String]
    let hasTranslation: Bool
    
    @Published private(set) var isFavorite: Bool
    @Published private(set) var speakingWord: String?
    @Published var isShowingPaywall = false
    
    private let audioService: AudioService
    private let favorites = Locator.favorites
    private let rateService = RateService()
    
    var title: String { verb.infinitive.value }
    
    init(verb: Verb,
         audioService: AudioService? = nil,
         languageService: LanguageService = .init(),
         sentencesService: SentencesService = .init()) {
        self.verb = verb
        self.audioService = audioService ?? AudioService(voiceService: .init())
        
        hasTranslation = languageService.hasTranslation
        sentences = sentencesService.items
            .filter { $0.word == verb.infinitive.value }
            .flatMap(\.sentences)
        isFavorite = favorites.verbs.contains(verb)
    }
    
    func play(_ word: Word) {
        guard FeatureToggle.isPaid else {
            isShowingPaywall = true
            return
        }
        
        audioService.play(text: word.value) { [weak self] in
            self?.speakingWord = word.value
        } stopHandler: { [weak self] in
            self?.speakingWord = nil
            self?.rateService.requestReviewIfAppropriate(minimumReviewWorthyActionCount: 20)
        }
    }
    
    func toggleFavorite() {
        if isFavorite {
            favorites.remove(verb)
        } else {
            guard !favorites.shouldPaywallBeShown else {
                isShowingPaywall = true
                return
            }
            
            favorites.add(verb)
        }
        
        isFavorite = favorites.verbs.contains(verb)
    }
    
    func refreshFavorite() {
        isFavorite = favorites.verbs.contains(verb)
    }
}
