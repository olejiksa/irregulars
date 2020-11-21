//
//  TestService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 20.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class TestService {
    
    lazy var items: [[String]] = {
        parser.read(from: .tests)
    }()
    
    private let parser = JSONParser<[String]>()
}
