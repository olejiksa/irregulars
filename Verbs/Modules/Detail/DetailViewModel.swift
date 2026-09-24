//
//  DetailViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class DetailViewModel {
    
    let verb: Verb
    let sentences: [String]
    let hasTranslation: Bool
    
    var isFavorite: Bool { favorites.verbs.contains(verb) }
    private(set) var speakingWord: String?
    var isShowingPlaybackSpeed = false
    
    private let audioService: AudioService
    private let favorites: Favorites
    private let rateService: RateService
    
    var title: String { verb.infinitive.value }
    
    init(verb: Verb,
         dependencies: AppDependencies,
         languageService: LanguageService = .init(),
         sentencesService: SentencesService = .init()) {
        self.verb = verb
        favorites = dependencies.favorites
        audioService = dependencies.makeAudioService()
        rateService = dependencies.makeRateService()
        
        hasTranslation = languageService.hasTranslation
        sentences = sentencesService.items
            .filter { $0.word == verb.infinitive.value }
            .flatMap(\.sentences)
    }
    
    func play(_ word: Word) {
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
            favorites.add(verb)
        }
    }
    
}
