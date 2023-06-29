//
//  TestListNewView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/23/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestListNewView: View {
    
    @StateObject private var viewModel = TestListNewViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    NavigationLink {
                        if let test = item.test {
                            let isNewTest = FeatureToggle.areNewTestsAvailable && test == .translation
                            if isNewTest {
                                TestNewView()
                            } else {
                                TestView(test: test)
                                    .edgesIgnoringSafeArea([.top, .bottom])
                                    .navigationTitle(test.title)
                            }
                        } else {
                            StatisticsView()
                                .edgesIgnoringSafeArea([.top, .bottom])
                                .navigationTitle("statistics".localized)
                        }
                    } label: {
                        TestListNewViewRow(item: item)
                    }
                }
            }
            .navigationTitle("tests".localized)
        }
    }
}

struct TestListNewViewRow: View {
    
    let item: TestItem
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            item.icon.imageSwiftUI?
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            
            if let title = item.test?.title ?? item.title {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
            }
            
            if let subtitle = item.test?.subtitle ?? item.subtitle {
                Text(subtitle)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
}
