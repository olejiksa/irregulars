//
//  AppLocalizable.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

// MARK: - Common

extension Localizable {
    
    static let translation = Localizable(
        NSLocalizedString("translation", comment: "Refers to the irregular verb translation caption"))
    static let examples = Localizable(
        NSLocalizedString("examples", comment: "Example sentences related to the verb"))
    
    static let widgetDescription = Localizable(
        NSLocalizedString("widget_description", comment: "The title displayed at the top of the add widget view"))
    static let widgetConfigurationDisplayTitle = Localizable(
        NSLocalizedString("widget_configuration_display_title", comment: "The short description displayed at the top of the add widget view"))
    
    static let voice = Localizable(
        NSLocalizedString("voice", comment: "The title of the voice list page"))
    static let voiceHint = Localizable(
        NSLocalizedString("voice_hint", comment: "The quick reference on how to customize the voice list"))
    
    static let demo = Localizable(
        NSLocalizedString("demo", comment: "Refers to verbs for tests available only in the free version"))
    static let derivatives = Localizable(
        NSLocalizedString("derivatives", comment: "Determines the display of irregular verbs with the prefixes be-, for(e)-, in-, inter-, mis-, off-, out-, over-, pre-, under-, with- and others"))
    static let regularVerbs = Localizable(
        NSLocalizedString("regular_verbs", comment: "Determines the display of verbs with both regular and irregular forms"))
    
    static let emptyVerbs = Localizable(
        NSLocalizedString("empty_verbs", comment: "Gives the cue what needs to be done to make this part of the screen stop empty"))
    static let emptyFavorites = Localizable(
        NSLocalizedString("empty_favorites", comment: "Explains what needs to be done for verbs to appear in Favorites"))
}

// MARK: - Accent Color

extension Localizable {
    
    static let accentColor = Localizable(
        NSLocalizedString("accent_color", comment: "Refers to both the Settings section and the title of the accent colors list page"))
    static let matchAppIconWithAccentColor = Localizable(
        NSLocalizedString("match_app_icon_with_accent_color", comment: "Refers to the section of tests where both second and third irregular verb forms are to be filled in"))
}

// MARK: - Test

extension Localizable {
    
    static let forms = Localizable(
        NSLocalizedString("forms", comment: "Refers to the section of tests where both second and third irregular verb forms are to be filled in"))
    static let sentences = Localizable(
        NSLocalizedString("sentences", comment: "Refers to the section of the tests where the missed word inside the sentence should be provided as the correct answer"))
    static let listening = Localizable(
        NSLocalizedString("listening", comment: "Refers to the listening section of the tests"))
}

// MARK: - Region

extension Localizable {
    
    static let australian = Localizable(
        NSLocalizedString("australian", comment: "Refers to Australian English"))
    static let irish = Localizable(
        NSLocalizedString("irish", comment: "Refers to Irish English"))
    static let indian = Localizable(
        NSLocalizedString("indian", comment: "Refers to Indian English"))
    static let southAfrican = Localizable(
        NSLocalizedString("south_african", comment: "Refers to South African English"))
    static let british = Localizable(
        NSLocalizedString("british", comment: "Refers to British English"))
    static let american = Localizable(
        NSLocalizedString("american", comment: "Refers to American English"))
}
