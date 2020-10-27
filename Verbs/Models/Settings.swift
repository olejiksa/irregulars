//
//  Settings.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

struct Settings: Codable {
    
    enum ListView: String, Codable, CaseIterable {
        case forms
        case translations
        
        init(description: String) {
            switch description {
            case "Verb forms".localized:
                self = .forms
            case "Translation".localized:
                self = .translations
            default:
                self = .forms
            }
        }
        
        var description: String {
            switch self {
            case .forms:
                return "Verb forms".localized
            case .translations:
                return "Translation".localized
            }
        }
    }
    
    var shouldRegularVerbsBeShown: Bool
    var shouldDerivedFormsBeShown: Bool
    var listView: ListView
    
    init() {
        shouldRegularVerbsBeShown = true
        shouldDerivedFormsBeShown = true
        listView = .forms
    }
}
