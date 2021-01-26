//
//  VerbDragItem.swift
//  Verbs
//
//  Created by Oleg Samoylov on 03.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import Foundation
import CoreServices

final class VerbDragItem: NSObject, Codable {
    
    let verb: Verb
    
    init(verb: Verb) {
        self.verb = verb
    }
}

// MARK: - NSItemProviderReading

extension VerbDragItem: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        [(kUTTypeData) as String]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> VerbDragItem {
        let decoder = JSONDecoder()
        do {
            let myJSON = try decoder.decode(VerbDragItem.self, from: data)
            return myJSON
        } catch {
            fatalError()
        }
    }
}

// MARK: - NSItemProviderWriting

extension VerbDragItem: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [(kUTTypeData) as String]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        let progress = Progress(totalUnitCount: 100)
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return progress
    }
}
