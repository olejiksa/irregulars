//
//  JSONParser.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

final class JSONParser<T: Decodable> {
    
    func read(from file: String) -> [T] {
        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "json") else { return [] }
        
        do {
            let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
            return try parse(data: data) ?? []
        } catch {
            print(error)
            return []
        }
    }
}

// MARK: - Private

private extension JSONParser {
    
    func parse(data: Data) throws -> [T]? {
        let jsonDecorder = JSONDecoder()
        return try jsonDecorder.decode([T].self, from: data)
    }
}
