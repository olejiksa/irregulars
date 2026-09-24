//
//  VerbsWidgetConfigurationIntent.swift
//  VerbsWidget
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import AppIntents

enum VerbsDisplayOption: String, AppEnum {
    
    case all
    case favorites
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        .init(name: "widget_display_option_title")
    }
    
    static var caseDisplayRepresentations: [VerbsDisplayOption: DisplayRepresentation] {
        [.all: .init(title: "widget_display_option_all"),
         .favorites: .init(title: "widget_display_option_favorites")]
    }
}

struct VerbsWidgetConfigurationIntent: WidgetConfigurationIntent {
    
    static let title: LocalizedStringResource = "widget_intent_title"
    static let description: IntentDescription = .init("widget_intent_description")
    
    @Parameter(title: "widget_display_option_title", default: .all)
    var displayOption: VerbsDisplayOption
}
