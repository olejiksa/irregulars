//
//  StatisticsKind.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum StatisticsKind {
    case learnedVerbs
    case correctAnswers
    
    var resetText: String {
        switch self {
        case .learnedVerbs:
            return "ResetStatisticsLearnedVerbs".localized
        case .correctAnswers:
            return "ResetStatisticsCorrectAnswer".localized
        }
    }
}
