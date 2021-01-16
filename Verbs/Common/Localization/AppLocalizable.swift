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

// MARK: - Settings

extension Localizable {
    
    static let infinitive = Localizable(
        NSLocalizedString("infinitive", comment: "The basic form of a verb, without an inflection binding it to a particular subject or tense"))
    static let pastSimple = Localizable(
        NSLocalizedString("past_simple", comment: "Used to show that a completed action took place at a specific time in the past"))
    static let pastParticiple = Localizable(
        NSLocalizedString("past_participle", comment: "A word that can be used as an adjective or to form verb tense"))
    
    static let links = Localizable(
        NSLocalizedString("links", comment: "The Links section title on the Settings page"))
    static let rateAndReview = Localizable(
        NSLocalizedString("rate_and_review", comment: "The App Store Rate and Review redirection link text"))
    static let privacyPolicy = Localizable(
        NSLocalizedString("privacy_policy", comment: "The Privacy Policy link text"))
    static let terms = Localizable(
        NSLocalizedString("terms", comment: "The Terms of Use link text"))
    static let contactUs = Localizable(
        NSLocalizedString("contact_us", comment: "The Contact Us link text"))
    static let shareApp = Localizable(
        NSLocalizedString("share_app", comment: "Lets a user to tell a friend about the app"))
    static let acknowledgements = Localizable(
        NSLocalizedString("acknowledgements", comment: "The title of the acknowledgements page as well as the corresponding link text"))
    
    static let about = Localizable(
        NSLocalizedString("about", comment: "The About section title on the Settings page"))
    static let developer = Localizable(
        NSLocalizedString("developer", comment: "Mentions the app's developer"))
    static let edition = Localizable(
        NSLocalizedString("edition", comment: "The app's edition: Lite, Pro"))
    static let version = Localizable(
        NSLocalizedString("version", comment: "The current version of the app"))
    static let betaTesting = Localizable(
        NSLocalizedString("beta_testing", comment: "The title of the section for beta testing participants"))
}

// MARK: - Accent Color

extension Localizable {
    
    static let accentColor = Localizable(
        NSLocalizedString("accent_color", comment: "Refers to both the Settings section and the title of the accent colors list page"))
    static let matchAppIconWithAccentColor = Localizable(
        NSLocalizedString("match_app_icon_with_accent_color", comment: "Referts to the app icon color matching action button"))
}

// MARK: - Test

extension Localizable {
    
    static let forms = Localizable(
        NSLocalizedString("forms", comment: "Refers to the section of tests where both second and third irregular verb forms are to be filled in"))
    static let sentences = Localizable(
        NSLocalizedString("sentences", comment: "Refers to the section of the tests where the missed word inside the sentence should be provided as the right answer"))
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

// MARK: - People

extension Localizable {
    
    static let olegSamoylov = Localizable(
        NSLocalizedString("oleg_samoylov", comment: "The full name of the app's develop"))
    static let sofiaSokolova = Localizable(
        NSLocalizedString("sofia_sokolova", comment: "Refers to Sofia Sokolova"))
    static let artemShumilov = Localizable(
        NSLocalizedString("artem_shumilov", comment: "Refers to Artem Shumilov"))
    static let elizabethKeplin = Localizable(
        NSLocalizedString("elizabeth_keplin", comment: "Refers to Elizabeth Keplin"))
    static let tatianaPerfilieva = Localizable(
        NSLocalizedString("tatiana_perfilieva", comment: "Refers to Tatiana Perfilieva"))
    static let vladislavPlotnikov = Localizable(
        NSLocalizedString("vladislav_plotnikov", comment: "Refers to Vladislav Plotnikov"))
    static let julianEduardo = Localizable(
        NSLocalizedString("julian_eduardo_couoh_pablo", comment: "Refers to Julián Eduardo"))
}
