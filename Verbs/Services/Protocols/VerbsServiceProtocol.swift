//
//  VerbsServiceProtocol.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

protocol VerbsServiceProtocol {
    
    var items: [Verb] { get }
    
    func verb(of infinitive: String?) -> Verb?
}
