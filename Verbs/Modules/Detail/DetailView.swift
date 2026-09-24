//
//  DetailView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @Bindable var viewModel: DetailViewModel
    
    @AppStorage(UserDefaults.Key.isPaid.rawValue, store: .shared)
    private var isPaid = false
    
    var body: some View {
        List {
            section(.infinitive, words: [viewModel.verb.infinitive])
            section(.pastSimple, words: viewModel.verb.simplePast ?? [])
            section(.pastParticiple, words: viewModel.verb.pastParticiple ?? [])
            
            if viewModel.hasTranslation {
                Section(String.localized(.translation)) {
                    Text(verbatim: viewModel.verb.translation)
                }
            }
            
            if !viewModel.sentences.isEmpty {
                Section(String.localized(.examples)) {
                    ForEach(viewModel.sentences, id: \.self) { sentence in
                        Text(highlighted(sentence))
                            .textSelection(.enabled)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    (viewModel.isFavorite ? SystemIcon.starFill : SystemIcon.star).imageSwiftUI
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.isShowingPlaybackSpeed = true
                } label: {
                    SystemIcon.ellipsis.imageSwiftUI
                }
                .popover(isPresented: $viewModel.isShowingPlaybackSpeed) {
                    PopoverView()
                        .presentationCompactAdaptation(.popover)
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Private

private extension DetailView {
    
    @ViewBuilder
    func section(_ header: Localizable, words: [Word]) -> some View {
        if !words.isEmpty {
            Section(String.localized(header)) {
                ForEach(words, id: \.self) { word in
                    row(for: word)
                }
            }
        }
    }
    
    func row(for word: Word) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: word.value)
                if isPaid {
                    Text(verbatim: word.transcription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
            }
            
            Spacer()
            
            Button {
                viewModel.play(word)
            } label: {
                let isSpeaking = viewModel.speakingWord == word.value
                (isSpeaking ? SystemIcon.stop : SystemIcon.play).imageSwiftUI?
                    .font(.title2)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("speak".localized)
        }
    }
    
    /// Emphasizes the verb form that the sentence is an example of.
    func highlighted(_ sentence: String) -> AttributedString {
        var attributed = AttributedString(sentence)
        let forms = [[viewModel.verb.infinitive],
                     viewModel.verb.simplePast ?? [],
                     viewModel.verb.pastParticiple ?? []].flatMap { $0 }
        
        for form in forms {
            guard let range = sentence.range(of: "\\b\(form.value)\\b",
                                             options: [.regularExpression, .caseInsensitive]),
                  let attributedRange = Range(range, in: attributed) else { continue }
            
            attributed[attributedRange].font = .body.bold()
            break
        }
        
        return attributed
    }
}

#Preview {
    NavigationStack {
        DetailView(viewModel: .init(verb: Verb(infinitive: Word(value: "arise", transcription: "/əˈrʌɪz/"),
                                               simplePast: [Word(value: "arose", transcription: "/əˈrəʊz/")],
                                               pastParticiple: [Word(value: "arisen", transcription: "/əˈrɪz(ə)n/")],
                                               hasRegular: false,
                                               isDerived: true)))
    }
}
