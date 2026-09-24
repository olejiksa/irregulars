//
//  SidebarViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Combine
import Foundation

@MainActor
final class SidebarViewModel: ObservableObject {
    
    @Published var selection: SidebarDestination? = .all
    
    /// Set by the view controller, which owns the split view columns.
    var onSelect: ((SidebarDestination) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: .reload)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    func select(_ destination: SidebarDestination?) {
        guard let destination = destination else { return }
        
        // Settings opens in the detail column and leaves the highlight where it was.
        guard destination != .settings else {
            onSelect?(destination)
            return
        }
        
        guard destination != selection else { return }
        
        selection = destination
        onSelect?(destination)
    }
    
    /// Dropping a verb onto the favourites row adds it, which is how the iPad has
    /// always worked.
    func addToFavorites(_ verb: Verb) {
        Locator.favorites.add(verb)
    }
    
    func restore(_ destination: SidebarDestination) {
        selection = destination
        onSelect?(destination)
    }
}
