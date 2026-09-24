//
//  SidebarView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UniformTypeIdentifiers

struct SidebarView: View {
    
    @Binding var selection: SidebarDestination?
    
    var body: some View {
        List(selection: $selection) {
            Section("verbs") {
                ForEach(SidebarDestination.verbs) { destination in
                    row(for: destination)
                }
            }
            
            #if !targetEnvironment(macCatalyst)
            Section("more") {
                row(for: .settings)
            }
            #endif
        }
        .listStyle(.sidebar)
        .navigationTitle(Bundle.main.productName ?? "")
    }
}

// MARK: - Private

private extension SidebarView {
    
    @ViewBuilder
    func row(for destination: SidebarDestination) -> some View {
        let label = Label {
            Text(verbatim: destination.title)
        } icon: {
            destination.icon.imageSwiftUI
        }
        .tag(destination)
        .accessibilityIdentifier(destination.accessibilityIdentifier.rawValue)
        
        if destination == .favorites {
            label.onDrop(of: [UTType.data], isTargeted: nil, perform: addDroppedVerbs)
        } else {
            label
        }
    }
    
    /// Dropping a verb onto the favourites row adds it, which is how the iPad has
    /// always worked.
    func addDroppedVerbs(_ providers: [NSItemProvider]) -> Bool {
        let loadable = providers.filter { $0.canLoadObject(ofClass: VerbDragItem.self) }
        guard !loadable.isEmpty else { return false }
        
        for provider in loadable {
            _ = provider.loadObject(ofClass: VerbDragItem.self) { item, _ in
                guard let verb = (item as? VerbDragItem)?.verb else { return }
                
                Task { @MainActor in Locator.favorites.add(verb) }
            }
        }
        
        return true
    }
}
