//
//  Similarity.swift
//  Verbs
//
//  Created by Oleg Samoylov on 25.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

/// Схожесть неправильных глаголов
enum Similarity: Int {
    /// Все формы имеют единое написание
    case all
    /// Совпадают вторая и третья формы
    case secondAndThird
    /// Совпадают первая и третья формы
    case firstAndSecond
    /// Заканчивающиеся на -en в третьей форме
    case thirdEn
    /// Заканчивающиеся на -own, -awn в третьей форме, имеют букву -w в конце первой
    case thirdOwnAndAwn
    
    var description: String {
        switch self {
        case .all:
            return "Все три формы повторяются"
        case .secondAndThird:
            return "Повторяются 2-я и 3-я формы"
        case .firstAndSecond:
            return "Повторяются 1-я и 3-я формы"
        case .thirdEn:
            return "Заканчивающиеся на -en в 3-й форме"
        case .thirdEn:
            return "Заканчивающиеся на -own или -awn в 3-й форме"
        }
    }
}
