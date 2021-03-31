//
//  Similarity.swift
//  Verbs
//
//  Created by Oleg Samoylov on 25.03.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

/// Схожесть неправильных глаголов
enum Similarity: Int, Codable {
    /// Все формы имеют единое написание
    case all
    /// Совпадают вторая и третья формы
    case secondAndThird
    /// Совпадают первая и третья формы
    case firstAndThird
    /// Заканчивающиеся на -en в третьей форме
    case thirdEn
    /// Заканчивающиеся на -own, -awn в третьей форме
    case thirdOwnAndAwn
    /// Другие
    case others
    
    var description: String {
        switch self {
        case .all:
            return "similarity_all".localized
        case .secondAndThird:
            return "similarity_second_and_third".localized
        case .firstAndThird:
            return "similarity_first_and_third".localized
        case .thirdEn:
            return "similarity_third_en".localized
        case .thirdOwnAndAwn:
            return "similarity_third_own_and_awn".localized
        case .others:
            return "similarity_others".localized
        }
    }
}

// MARK: - Comparable

extension Similarity: Comparable {
    
    static func <(lhs: Similarity, rhs: Similarity) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
