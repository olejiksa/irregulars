//
//  VerbsWidget.swift
//  VerbsWidget
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import AppIntents
import SwiftUI
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    
    func placeholder(in context: Context) -> VerbEntry {
        .init(date: Date(), state: .empty)
    }

    func snapshot(for configuration: VerbsWidgetConfigurationIntent,
                  in context: Context) async -> VerbEntry {
        let verb = Verb(infinitive: Word(value: "arise", transcription: "/əˈrʌɪz/"),
                        simplePast: [Word(value: "arose", transcription: "/əˈrəʊz/")],
                        pastParticiple: [Word(value: "arisen", transcription: "/əˈrɪz(ə)n/")],
                        hasRegular: false,
                        isDerived: true)
        return VerbEntry(date: Date(), state: .data(verb))
    }

    func timeline(for configuration: VerbsWidgetConfigurationIntent,
                  in context: Context) async -> Timeline<VerbEntry> {
        let entries = await entries(for: configuration.displayOption)
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    /// The verbs and the favourites both live on the main actor. The widget process is
    /// short-lived, so it builds its own small graph rather than sharing the app's.
    @MainActor
    private func entries(for displayOption: VerbsDisplayOption) -> [VerbEntry] {
        let favorites = Favorites()
        let preferences = Preferences()
        let catalogue = VerbCatalogue(favorites: favorites)
        
        let verbs: [Verb]
        
        switch displayOption {
        case .all:
            verbs = catalogue.verbs(includingRegular: preferences.showsRegularVerbs,
                                    includingDerived: preferences.showsDerivatives)
        case .favorites:
            verbs = Array(favorites.verbs)
        }
        
        guard !verbs.isEmpty else {
            return [VerbEntry(date: Date(), state: .empty)]
        }
        
        var entries: [VerbEntry] = []
        
        for index in 0..<8 {
            guard let verb = verbs.randomElement() else { continue }
            entries.append(VerbEntry(date: date(at: index), state: .data(verb)))
        }
        
        return entries
    }
    
    /// Each entry is shown 15 minutes later than the previous one.
    private func date(at index: Int) -> Date {
        Calendar.autoupdatingCurrent.date(byAdding: .minute, value: 15 * index, to: Date()) ?? Date()
    }
}

struct VerbEntry: TimelineEntry {
    
    enum State {
        case data(Verb)
        case empty
    }
    
    let date: Date
    let state: State
}

struct VerbsWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily
    
    private let languageService = LanguageService()

    var body: some View {
        switch (widgetFamily, entry.state) {
        case (.systemSmall, .data(let verb)):
            small(with: verb)
        case (.systemMedium, .data(let verb)):
            medium(with: verb)
        case (.systemLarge, .data(let verb)):
            large(with: verb)
        default:
            Text("No data to display")
                .multilineTextAlignment(.center)
                .font(.caption)
                .padding(20)
        }
    }
    
    private func small(with verb: Verb) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Infinitive")
                .font(.caption)
            Text(verbatim: verb.infinitive.value)
                .bold()
                .lineLimit(1)
            if let simplePast = verb.simplePast?.first {
                Text("Past Simple")
                    .font(.caption)
                Text(verbatim: simplePast.value)
                    .bold()
                    .truncationMode(.head)
                    .lineLimit(1)
            }
            if let pastParticiple = verb.pastParticiple?.first {
                Text("Past Participle")
                    .lineLimit(1)
                    .font(.caption)
                Text(verbatim: pastParticiple.value)
                    .bold()
                    .truncationMode(.head)
                    .lineLimit(1)
            }
        }
        .widgetURL(verb.url)
        .padding(20)
    }
    
    private func medium(with verb: Verb) -> some View {
        VStack(alignment: .center, spacing: 15) {
            HStack(alignment: .center, spacing: 20) {
                VStack(alignment: .center, spacing: 10) {
                    Text("Infinitive")
                        .font(.caption)
                    Text(verbatim: verb.infinitive.value)
                        .bold()
                        .lineLimit(1)
                    Text(verbatim: verb.infinitive.transcription)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }.frame(maxWidth: .infinity)
                if let simplePast = verb.simplePast?.first {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Past Simple")
                            .font(.caption)
                        Text(verbatim: simplePast.value)
                            .bold()
                            .truncationMode(.head)
                            .lineLimit(1)
                        Text(verbatim: simplePast.transcription)
                            .foregroundColor(.secondary)
                            .truncationMode(.head)
                            .lineLimit(1)
                    }.frame(maxWidth: .infinity)
                }
                if let pastParticiple = verb.pastParticiple?.first {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Past Participle")
                            .lineLimit(1)
                            .font(.caption)
                        Text(verbatim: pastParticiple.value)
                            .bold()
                            .truncationMode(.head)
                            .lineLimit(1)
                        Text(verbatim: pastParticiple.transcription)
                            .foregroundColor(.secondary)
                            .truncationMode(.head)
                            .lineLimit(1)
                    }.frame(maxWidth: .infinity)
                }
            }
            if languageService.hasTranslation {
                Text(verbatim: verb.translation)
                    .font(.footnote)
                    .lineLimit(1)
            }
        }
        .widgetURL(verb.url)
        .padding(20)
    }
    
    private func large(with verb: Verb) -> some View {
        let sentences = SentencesService().items
            .filter { $0.word == verb.infinitive.value }
            .flatMap(\.sentences)
        let stack = VStack(alignment: .center, spacing: 15) {
            HStack(alignment: .center, spacing: 10) {
                Text("Infinitive")
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                Text(verbatim: verb.infinitive.value)
                    .foregroundColor(.secondary)
                    .bold()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                Text(verbatim: verb.infinitive.transcription)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
            }
            if let simplePast = verb.simplePast?.first {
                HStack(alignment: .center, spacing: 10) {
                    Text("Past Simple")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                    Text(verbatim: simplePast.value)
                        .bold()
                        .truncationMode(.head)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                    Text(verbatim: simplePast.transcription)
                        .foregroundColor(.secondary)
                        .truncationMode(.head)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                }
            }
            if let pastParticiple = verb.pastParticiple?.first {
                HStack(alignment: .center, spacing: 10) {
                    Text("Past Participle")
                        .font(.caption)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                    Text(verbatim: pastParticiple.value)
                        .foregroundColor(.secondary)
                        .bold()
                        .truncationMode(.head)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                    Text(verbatim: pastParticiple.transcription)
                        .truncationMode(.head)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                }
            }
            if languageService.hasTranslation {
                Text(verbatim: verb.translation)
                    .font(.footnote)
            }
            ForEach(sentences, id: \.self) { sentence in
                Text(verbatim: sentence)
            }
        }
        .widgetURL(verb.url)
        .padding(20)
        return stack
    }
}

@main
struct VerbsWidget: Widget {
    let kind: String = "VerbsWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,
                               intent: VerbsWidgetConfigurationIntent.self,
                               provider: Provider()) { entry in
            VerbsWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(UIColor.systemBackground)
                }
        }
        .configurationDisplayName(String(localized: "widget_configuration_display_title"))
        .description(String(localized: "widget_description"))
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium) {
    VerbsWidget()
} timeline: {
    let verb = Verb(infinitive: Word(value: "arisearise", transcription: "/əˈrʌɪz/"),
                    simplePast: [Word(value: "arosearisearise", transcription: "/əˈrəʊz/")],
                    pastParticiple: [Word(value: "arisenarisearise", transcription: "/əˈrɪz(ə)n/")],
                    hasRegular: false,
                    isDerived: true)
    VerbEntry(date: Date(), state: .data(verb))
}
