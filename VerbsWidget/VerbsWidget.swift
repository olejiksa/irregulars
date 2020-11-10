//
//  VerbsWidget.swift
//  VerbsWidget
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    private let service = VerbsService()
    
    func placeholder(in context: Context) -> VerbEntry {
        let verb = Verb(infinitive: Word(),
                        simplePast: [Word()],
                        pastParticiple: [Word()],
                        hasRegular: false,
                        isDerived: false)
        return .init(date: Date(), verb: verb)
    }

    func getSnapshot(in context: Context, completion: @escaping (VerbEntry) -> ()) {
        let verb = Verb(infinitive: Word(value: "arise", transcription: "/əˈrʌɪz/"),
                        simplePast: [Word(value: "arose", transcription: "/əˈrəʊz/")],
                        pastParticiple: [Word(value: "arisen", transcription: "/əˈrɪz(ə)n/")],
                        hasRegular: false,
                        isDerived: true)
        let entry = VerbEntry(date: Date(), verb: verb)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [VerbEntry] = []
        for _ in 1...24*4 {
            guard let verb = service.randomItem else { continue }
            let date = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            let entry = VerbEntry(date: date, verb: verb)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct VerbEntry: TimelineEntry {
    let date: Date
    let verb: Verb
}

struct VerbsWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) private var widgetFamily

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            VStack(alignment: .leading, spacing: 5) {
                Text("Infinitive")
                    .font(.caption)
                Text(entry.verb.infinitive.value)
                    .bold()
                    .lineLimit(1)
                Text("Simple Past")
                    .font(.caption)
                if let simplePast = entry.verb.simplePast.first {
                    Text(simplePast.shortened)
                        .bold()
                        .truncationMode(.head)
                        .lineLimit(1)
                }
                if let pastParticiple = entry.verb.pastParticiple?.first {
                    Text("Past Participle")
                        .font(.caption)
                    Text(pastParticiple.shortened)
                        .bold()
                        .truncationMode(.head)
                        .lineLimit(1)
                }
            }
            .widgetURL(entry.verb.url)
            .padding(20)
        case .systemMedium:
            VStack(alignment: .center, spacing: 15) {
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .center, spacing: 10) {
                        Text("Infinitive")
                            .font(.caption)
                        Text(entry.verb.infinitive.value)
                            .bold()
                            .lineLimit(1)
                        Text(entry.verb.infinitive.transcription)
                            .lineLimit(1)
                    }
                    if let simplePast = entry.verb.simplePast.first {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Simple Past")
                                .font(.caption)
                            Text(simplePast.shortened)
                                .bold()
                                .truncationMode(.head)
                                .lineLimit(1)
                            Text(simplePast.transcription)
                                .truncationMode(.head)
                                .lineLimit(1)
                        }
                    }
                    if let pastParticiple = entry.verb.pastParticiple?.first {
                        VStack(alignment: .center, spacing: 10) {
                            Text("Past Participle")
                                .font(.caption)
                            Text(pastParticiple.shortened)
                                .bold()
                                .truncationMode(.head)
                                .lineLimit(1)
                            Text(pastParticiple.transcription)
                                .truncationMode(.head)
                                .lineLimit(1)
                        }
                    }
                }
                if LanguageService().hasTranslation {
                    Text(entry.verb.translation)
                        .italic()
                        .lineLimit(1)
                }
            }
            .widgetURL(entry.verb.url)
            .padding(20)
        default:
            Text("Not Supported")
        }
    }
}

@main
struct VerbsWidget: Widget {
    private let userDefaultsService = UserDefaultsService()
    let kind: String = "VerbsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VerbsWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
        }
        .configurationDisplayName("WidgetConfigurationDisplayTitle".localized)
        .description("WidgetDescription".localized)
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
        VerbsWidgetEntryView(entry: VerbEntry(date: Date(), verb: verb))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
