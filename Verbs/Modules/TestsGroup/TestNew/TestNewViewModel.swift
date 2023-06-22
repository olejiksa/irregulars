//
//  TestNewViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/23/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

final class TestNewViewModel: ObservableObject {
    
    @Published var current: Verb?
    @Published var answers: [Verb] = []
    @Published var progress: Float = 1
    @Published var isFinished = false
    
    var count: Float = 20
    var progressInfo: String {
        "Вопрос \(Int(progress)) из \(Int(count))"
    }
    var resultInfo: String {
        """
Поздравляем, ты дошёл до конца!
Правильных ответов: \(correctAnswers)
Неправильных ответов: \(incorrectAnswers)
"""
    }
    
    private var correctAnswers = 0
    private var incorrectAnswers = 0
    
    private let listService = VerbsService()
    
    init() {
        update()
    }
    
    func next(verb: Verb? = nil) {
        countAnswer(verb: verb)
        
        guard progress < count else {
            isFinished = true
            return
        }
        
        update()
        
        progress += 1
    }
    
    func reset() {
        update()
        
        correctAnswers = 0
        incorrectAnswers = 0
        progress = 0
    }
}

private extension TestNewViewModel {
    
    func countAnswer(verb: Verb?) {
        if progress <= count, let verb {
            if verb == current {
                correctAnswers += 1
            } else {
                incorrectAnswers += 1
            }
        }
    }
    
    func update() {
        current = listService.randomItem
        answers = [
            current,
            listService.randomItem,
            listService.randomItem,
            listService.randomItem
        ].compactMap { $0 }.shuffled()
    }
}
