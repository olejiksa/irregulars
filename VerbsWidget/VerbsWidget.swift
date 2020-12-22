//
//  VerbsWidget.swift
//  VerbsWidget
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
    
    private var service: VerbsService = {
        let service = VerbsService()
        service.shouldDerivativesBeShown = UserDefaults.shared.bool(for: .derivatives)
        service.shouldRegularVerbsBeShown = UserDefaults.shared.bool(for: .regularVerbs)
        return service
    }()
    
    func placeholder(in context: Context) -> VerbEntry {
        .init(date: Date(), state: .empty)
    }

    func getSnapshot(for configuration: VerbsIntentIntent,
                     in context: Context,
                     completion: @escaping (VerbEntry) -> ()) {
        let verb = Verb(infinitive: Word(value: "arise", transcription: "/əˈrʌɪz/"),
                        simplePast: [Word(value: "arose", transcription: "/əˈrəʊz/")],
                        pastParticiple: [Word(value: "arisen", transcription: "/əˈrɪz(ə)n/")],
                        hasRegular: false,
                        isDerived: true)
        let entry = VerbEntry(date: Date(), state: .data(verb))
        completion(entry)
    }

    func getTimeline(for configuration: VerbsIntentIntent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [VerbEntry] = []
        switch configuration.displayOption {
        case .unknown, .all:
            for _ in 1...8 {
                guard let verb = service.randomItem else { continue }
                let date = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
                let entry = VerbEntry(date: date, state: .data(verb))
                entries.append(entry)
            }
        case .favorites:
            guard !Locator.favorites.verbs.isEmpty else {
                let entry = VerbEntry(date: Date(), state: .empty)
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
                return
            }
            
            for _ in 1...8 {
                guard let verb = Locator.favorites.verbs.randomElement() else { continue }
                let date = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
                let entry = VerbEntry(date: date, state: .data(verb))
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
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
            Text("Simple Past")
                .font(.caption)
            if let simplePast = verb.simplePast?.first {
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
                        .lineLimit(1)
                }.frame(maxWidth: .infinity)
                if let simplePast = verb.simplePast?.first {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Simple Past")
                            .font(.caption)
                        Text(verbatim: simplePast.value)
                            .bold()
                            .truncationMode(.head)
                            .lineLimit(1)
                        Text(verbatim: simplePast.transcription)
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
                            .truncationMode(.head)
                            .lineLimit(1)
                    }.frame(maxWidth: .infinity)
                }
            }
            if languageService.hasTranslation {
                Text(verbatim: verb.translation)
                    .italic()
                    .lineLimit(1)
            }
        }
        .widgetURL(verb.url)
        .padding(20)
    }
    
    private func large(with verb: Verb) -> some View {
        let sentences = SentencesService().items
            .filter { $0.word == verb.infinitive.value }
            .flatMap { $0.sentences }
        let stack = VStack(alignment: .center, spacing: 15) {
            HStack(alignment: .center, spacing: 10) {
                Text("Infinitive")
                    .font(.caption)
                    .frame(maxWidth: .infinity)
                Text(verbatim: verb.infinitive.value)
                    .bold()
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                Text(verbatim: verb.infinitive.transcription)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
            }
            if let simplePast = verb.simplePast?.first {
                HStack(alignment: .center, spacing: 10) {
                    Text("Simple Past")
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                    Text(verbatim: simplePast.value)
                        .bold()
                        .truncationMode(.head)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                    Text(verbatim: simplePast.transcription)
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
        IntentConfiguration(kind: kind, intent: VerbsIntentIntent.self, provider: Provider()) { entry in
            VerbsWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
        }
        .configurationDisplayName("widget_configuration_display_title".localized)
        .description("widget_description".localized)
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct VerbsWidget_Previews: PreviewProvider {
    static var previews: some View {
        let verb = Verb(infinitive: Word(value: "arisearise", transcription: "/əˈrʌɪz/"),
                        simplePast: [Word(value: "arosearisearise", transcription: "/əˈrəʊz/")],
                        pastParticiple: [Word(value: "arisenarisearise", transcription: "/əˈrɪz(ə)n/")],
                        hasRegular: false,
                        isDerived: true)
        VerbsWidgetEntryView(entry: VerbEntry(date: Date(), state: .data(verb)))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
