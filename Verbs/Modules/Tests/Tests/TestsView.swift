//
//  TestsView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestsView: View {
    
    @ObservedObject var viewModel: TestsViewModel
    
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
