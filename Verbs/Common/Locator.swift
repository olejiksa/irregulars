//
//  Locator.swift
//  Verbs
//
//  Created by Oleg Samoylov on 09.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

struct Locator {
    
    static var areNotificationsAvailable = false
    
    static let favorites = Favorites()
    static let favoritesService = FavoritesService()
    static let purchaseService = PurchaseService()
    static let statistics = Statistics()
    static let mistakes = Mistakes()
}
