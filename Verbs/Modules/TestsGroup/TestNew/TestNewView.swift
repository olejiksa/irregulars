//
//  TestNewView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestNewView: View {
    
    @StateObject private var viewModel = TestNewViewModel()
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            ProgressView(viewModel.progressInfo, value: viewModel.progress, total: viewModel.count)
                .padding(EdgeInsets(top: 10, leading: 30, bottom: 10, trailing: 30))
            List {
                SwiftUI.Section(String.localized(.infinitive)) {
                    TestNewViewRow(viewModel.current?.infinitive.value ?? "")
                }
                SwiftUI.Section(String.localized(.translation)) {
                    ForEach(viewModel.answers) { verb in
                        TestNewViewRow(verb.translation)
                            .onTapGesture {
                                viewModel.next(verb: verb)
                            }
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 60)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(String.localized(.translation))
        }
        .alert(viewModel.resultInfo, isPresented: $viewModel.isFinished) {
            Button("Пройти ещё раз", role: .none) {
                viewModel.reset()
            }
            Button("Закрыть тест", role: .cancel) {
                presentation.wrappedValue.dismiss()
            }
        }
    }
}

struct TestNewView_Previews: PreviewProvider {
    
    static var previews: some View {
        TestNewView()
    }
}
