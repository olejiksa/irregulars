//
//  VerbsWidget.swift
//  VerbsWidget
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    private let service = VerbsService()
    
    func placeholder(in context: Context) -> VerbEntry {
        let verb = Verb(infinitive: Word(),
                        simplePast: Word(),
                        pastParticiple: Word(),
                        hasRegular: false,
                        isDerived: false)
        return .init(date: Date(),
                     verb: verb,
                     configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (VerbEntry) -> ()) {
        let verb = Verb(infinitive: Word(value: "arise"),
                        simplePast: Word(value: "arose"),
                        pastParticiple: Word(value: "arisen"),
                        hasRegular: false,
                        isDerived: true)
        let entry = VerbEntry(date: Date(),
                              verb: verb,
                              configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [VerbEntry] = []
        for _ in 1...4 {
            guard let verb = service.randomItem else { continue }
            let date = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            let entry = VerbEntry(date: date,
                                  verb: verb,
                                  configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct VerbEntry: TimelineEntry {
    let date: Date
    let verb: Verb
    let configuration: ConfigurationIntent
}

struct VerbsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Infinitive")
                .font(.caption)
            Text(entry.verb.infinitive.value)
                .bold()
            Text("Simple Past")
                .font(.caption)
            Text(entry.verb.simplePastShortened)
                .bold()
            if let pastParticiple = entry.verb.pastParticipleShortened {
                Text("Past Participle")
                    .font(.caption)
                Text(pastParticiple)
                    .bold()
                    .lineLimit(1)
            }
        }.widgetURL(entry.verb.url)
    }
}

@main
struct VerbsWidget: Widget {
    let kind: String = "VerbsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            VerbsWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
        }
        .configurationDisplayName("Слово дня")
        .description("Запоминайте неправильные глаголы легко и просто каждый день")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct VerbsWidget_Previews: PreviewProvider {
    static var previews: some View {
        let verb = Verb(infinitive: Word(value: "arise"),
                        simplePast: Word(value: "arose"),
                        pastParticiple: Word(value: "arisen"),
                        hasRegular: false,
                        isDerived: true)
        VerbsWidgetEntryView(entry: VerbEntry(date: Date(),
                                              verb: verb,
                                              configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
