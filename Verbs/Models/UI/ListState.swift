//
//  ListState.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

enum ListState {
    
    case empty(String)
    case data
    case searchNotFound(String)
    case searchStarted(String)
    
    init(isSearchActive: Bool, isSearchTextEmpty: Bool, areItemsEmpty: Bool) {
        switch (isSearchActive, isSearchTextEmpty, areItemsEmpty) {
        case (true, false, true):
            self = .searchNotFound("not_found".localized)
        case (true, true, true):
            self = .searchStarted("search_hint".localized)
        case (_, _, false):
            self = .data
        case (false, _, true):
            self = .empty("empty_favorites".localized)
        }
    }
}
