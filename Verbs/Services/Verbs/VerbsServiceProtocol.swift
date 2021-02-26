//
//  VerbsServiceProtocol.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol VerbsServiceProtocol: class {
    
    var favoritesOnly: Bool { get }
    
    var items: [Verb] { get }
    var searchedItems: [Verb] { get }
    var groupedItems: [[Verb]] { get }
    
    var searchText: String { get set }
    
    var shouldTranslationBeShown: Bool { get set }
    var shouldRegularVerbsBeShown: Bool { get set }
    var shouldDerivativesBeShown: Bool { get set }
    
    func verb(of infinitive: String?) -> Verb?
    func indexPath(of infinitive: String?) -> IndexPath?
}
