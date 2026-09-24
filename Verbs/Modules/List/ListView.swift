//
//  ListView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var viewModel: ListViewModel
    
    var body: some View {
        ZStack {
            list
            
            if let message = viewModel.state.message {
                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(uiColor: .systemBackground))
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.state.message)
        .sheet(isPresented: $viewModel.isShowingPaywall) {
            PaywallView()
        }
    }
}

// MARK: - Private

private extension ListView {
    
    var selection: Binding<Verb?> {
        .init(get: { viewModel.selectedVerb },
              set: { viewModel.select($0) })
    }
    
    var list: some View {
        ScrollViewReader { proxy in
            List(selection: selection) {
                if viewModel.isSearchActive {
                    ForEach(viewModel.searchResults) { verb in
                        row(for: verb)
                    }
                } else {
                    ForEach(viewModel.sections) { section in
                        Section(section.header) {
                            ForEach(section.verbs) { verb in
                                row(for: verb)
                            }
                        }
                        .sectionIndexLabel(section.header.first.map(String.init))
                    }
                }
            }
            .listSectionIndexVisibility(viewModel.showsSectionIndex ? .visible : .hidden)
            .environment(\.editMode, .constant(viewModel.isEditing ? .active : .inactive))
            .onChange(of: viewModel.scrollToTopToken) {
                guard let first = viewModel.sections.first?.verbs.first else { return }
                withAnimation { proxy.scrollTo(first.id, anchor: .top) }
            }
        }
    }
    
    @ViewBuilder
    func row(for verb: Verb) -> some View {
        Group {
            if viewModel.showsTranslation {
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: verb.infinitive.value)
                    Text(verbatim: verb.translation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack(spacing: 8) {
                    Text(verbatim: verb.infinitive.value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(verbatim: verb.simplePast?.first?.value ?? "—")
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text(verbatim: verb.pastParticiple?.first?.value ?? "—")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .lineLimit(1)
            }
        }
        .tag(verb)
        .contextMenu {
            favoriteButton(for: verb)
        } preview: {
            DetailView(viewModel: .init(verb: verb))
        }
        .swipeActions(edge: .trailing) {
            if viewModel.favoritesOnly {
                Button(role: .destructive) {
                    viewModel.remove(verb)
                } label: {
                    Text("remove")
                }
            }
        }
        .if(viewModel.canDrag(verb)) { view in
            view.onDrag { NSItemProvider(object: VerbDragItem(verb: verb)) }
        }
    }
    
    @ViewBuilder
    func favoriteButton(for verb: Verb) -> some View {
        let isFavorite = viewModel.isFavorite(verb)
        let title = viewModel.favoritesOnly
            ? "remove"
            : (isFavorite ? "remove_from_favorites" : "add_to_favorites")
        let icon: SystemIcon = isFavorite || viewModel.favoritesOnly ? .starSlash : .star
        
        Button {
            viewModel.toggleFavorite(verb)
        } label: {
            Label {
                Text(LocalizedStringKey(title))
            } icon: {
                icon.imageSwiftUI
            }
        }
    }
}

// MARK: - Conditional Modifier

private extension View {
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
