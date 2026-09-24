//
//  TestsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestsView: View {
    
    var viewModel: TestsViewModel
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(viewModel.rows) { row in
                    Button {
                        viewModel.select(row)
                    } label: {
                        content(for: row)
                    }
                    .accessibilityIdentifier(row.accessibilityIdentifier?.rawValue ?? row.id)
                }
            }
            .onChange(of: viewModel.scrollToTopToken) {
                guard let first = viewModel.rows.first else { return }
                withAnimation { proxy.scrollTo(first.id, anchor: .top) }
            }
        }
        .navigationTitle("tests")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("", selection: viewModel.scopeBinding) {
                        if !viewModel.isPaid {
                            Label("demo", systemImage: SystemIcon.twentyFive.rawValue)
                                .tag(TestsViewModel.Scope.demo)
                        }
                        Label("all", systemImage: SystemIcon.listBullet.rawValue)
                            .tag(TestsViewModel.Scope.all)
                        Label("favorites", systemImage: SystemIcon.star.rawValue)
                            .tag(TestsViewModel.Scope.favorites)
                    }
                    .pickerStyle(.inline)
                    
                    if viewModel.isPaid, viewModel.scopeBinding.wrappedValue == .all {
                        Toggle("regular_verbs", isOn: viewModel.showsRegularsBinding)
                        Toggle("derivatives", isOn: viewModel.showsDerivativesBinding)
                    }
                } label: {
                    (viewModel.isFiltered ? SystemIcon.unfilter : SystemIcon.filter).imageSwiftUI
                }
            }
        }
    }
}

// MARK: - Private

private extension TestsView {
    
    func content(for row: TestsView.Row) -> some View {
        HStack(spacing: 14) {
            row.icon.imageSwiftUI?
                .font(.title2)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(verbatim: row.title)
                    .foregroundStyle(.primary)
                Text(verbatim: row.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}

private extension TestsView {
    
    typealias Row = TestsViewModel.Row
}
