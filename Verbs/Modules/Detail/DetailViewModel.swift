//
//  DetailViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Combine
import Foundation
import Observation

@MainActor
@Observable
final class DetailViewModel {
    
    let verb: Verb
    let sentences: [String]
    let hasTranslation: Bool
    
    private(set) var isFavorite: Bool
    private(set) var speakingWord: String?
    var isShowingPaywall = false
    var isShowingPlaybackSpeed = false
    
    private let audioService: AudioService
    private let favorites = Locator.favorites
    private let rateService = RateService()
    private var cancellables = Set<AnyCancellable>()
    
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
        
        NotificationCenter.default.publisher(for: .favorites)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.refreshFavorite() }
            .store(in: &cancellables)
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
