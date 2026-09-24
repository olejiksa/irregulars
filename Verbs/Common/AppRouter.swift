//
//  AppRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Combine
import SwiftUI

/// What the verbs column can push.
enum VerbsRoute: Hashable {
    case verb(Verb)
}

/// What the tests column can push.
enum TestsRoute: Hashable {
    case test(Test)
    case statistics
}

/// The whole navigation state of the app. The scene delegate writes to it when a
/// deep link, a Spotlight result or a home screen shortcut arrives; the views read it.
@MainActor
@Observable
final class AppRouter {
    
    /// The delegates are created by UIKit and the views by SwiftUI, so they meet here.
    static let shared = AppRouter()
    
    var destination: SidebarDestination = .all {
        didSet {
            // A new section starts with an empty detail column.
            guard destination != oldValue else { return }
            
            verbsRoute = nil
            testsRoute = nil
        }
    }
    
    var verbsRoute: VerbsRoute?
    var testsRoute: TestsRoute?
    
    /// Screens the Mac menu bar opens, which has no column of its own to push into.
    var menuScreen: MenuScreen?
    
    /// Bumped by the print command in the menu bar.
    private(set) var printRequests = 0
    
    /// Text handed over by Spotlight or by the search shortcut.
    var pendingSearch: String?
    
    var verbsPath: Binding<[VerbsRoute]> {
        .init(get: { [weak self] in self?.verbsRoute.map { [$0] } ?? [] },
              set: { [weak self] in self?.verbsRoute = $0.last })
    }
    
    var testsPath: Binding<[TestsRoute]> {
        .init(get: { [weak self] in self?.testsRoute.map { [$0] } ?? [] },
              set: { [weak self] in self?.testsRoute = $0.last })
    }
    
    // MARK: Entry points
    
    /// A tap in whichever list is on screen: it must not move the reader to another tab.
    func open(_ verb: Verb) {
        verbsRoute = .verb(verb)
    }
    
    /// A deep link, which has no list on screen to start from.
    func show(_ verb: Verb) {
        if destination != .favorites {
            destination = .all
        }
        
        verbsRoute = .verb(verb)
    }
    
    func search(_ text: String) {
        destination = .all
        verbsRoute = nil
        pendingSearch = text
    }
    
    func showFavorites() {
        destination = .favorites
        verbsRoute = nil
    }
    
    func showTests() {
        destination = .tests
        testsRoute = nil
    }
    
    func requestPrint() {
        printRequests += 1
    }
    
    func showStatistics() {
        destination = .tests
        testsRoute = .statistics
    }
}

// MARK: - Menu screens

enum MenuScreen: Int, Identifiable {
    
    case voice
    case notifications
    case paywall
    
    var id: Int { rawValue }
}
