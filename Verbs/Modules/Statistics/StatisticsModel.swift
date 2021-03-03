//
//  StatisticsModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 04.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

struct StatisticsModel {
    
    let verbsCount: Int
    let learnedWordsCount: Int
    let wordsInProgressCount: Int
    let totalAnswersCount: Int
    let translationAnswersCount: Int
    let formsAnswersCount: Int
    let sentenceAnswersCount: Int
    let listeningAnswersCount: Int
    let mistakes: [Verb]
}
