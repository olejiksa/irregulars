//
//  StatisticsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 8/6/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
    
    @State private var viewModel = StatisticsViewModel()
    
    var body: some View {
        List {
            if !viewModel.isPaid {
                Section {
                    Button("upgrade_to_pro") {
                        viewModel.isShowingPaywall = true
                    }
                } header: {
                    Text("activation")
                } footer: {
                    Text("pro_suggestion_statistics".localized(with: viewModel.counts))
                }
            }
            Section {
                ProgressRow(value: viewModel.learnedVerbsCount, maximum: viewModel.versbCount)
            } header: {
                Text("learned_verbs")
            } footer: {
                Text("learned_verbs_footer")
            }
            Section("in_progress") {
                ProgressRow(value: viewModel.wordsInProgressCount, maximum: viewModel.versbCount)
            }
//            Section {
//                HStack {
//                    Text("tell")
//                    Spacer()
//                    Button {
//
//                    } label: {
//                        SystemIcon.star.imageSwiftUI?
//                            .foregroundColor(AccentColor.current.colorSwiftUI)
//                    }
//                }
//            } header: {
//                Text("frequent_mistakes")
//            } footer: {
//                Text("frequent_mistakes_footer")
//            }
            Section {
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        let answeredCorrectlyString = String(
                            format: "answered_correctly_count".localized,
                            viewModel.answeredCorrectlyTotal
                        )
                        Text("\(viewModel.answeredCorrectlyTotal)")
                            .font(.system(size: 40, weight: .bold))
                        Text(answeredCorrectlyString)
                            .font(.caption)
                    }
                    Spacer()
                }
            } header: {
                Text("your_efforts")
            } footer: {
                Text("using_hints_gives_you_no_points")
            }
            Section("including") {
                if viewModel.hasTranslation {
                    RightDetailRow(title: "translation", subtitle: "\(viewModel.answeredCorrectlyTranslation)")
                }
                RightDetailRow(title: "forms", subtitle: "\(viewModel.answeredCorrectlyWriting)")
                RightDetailRow(title: "sentences", subtitle: "\(viewModel.answeredCorrectlySentences)")
                RightDetailRow(title: "listening", subtitle: "\(viewModel.answeredCorrectlyListening)")
            }
            Section("reset") {
                Button("erase_learned_verbs") {
                    viewModel.startErasing(.learnedVerbs)
                }
                Button("erase_correct_answers") {
                    viewModel.startErasing(.correctAnswers)
                }
            }
        }
        .navigationTitle("statistics")
        .navigationBarTitleDisplayMode(.inline)
        .alert("attention", isPresented: $viewModel.isShowingEraseLearnedVerbsAlert) {
            Button("cancel", role: .cancel) {}
            Button("yes", role: .destructive) {
                viewModel.erase(.learnedVerbs)
            }
        } message: {
            Text("reset_statistics_learned_verbs")
        }
        .alert("attention", isPresented: $viewModel.isShowingEraseCorrectAnswersAlert) {
            Button("cancel", role: .cancel) {}
            Button("yes", role: .destructive) {
                viewModel.erase(.correctAnswers)
            }
        } message: {
            Text("reset_statistics_correct_answers")
        }
        .sensoryFeedback(.warning, trigger: viewModel.warningFeedback)
        .sheet(isPresented: $viewModel.isShowingPaywall) {
            PaywallView()
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            StatisticsView()
        }
    }
}
