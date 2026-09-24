//
//  VerbsApp.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/18/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import CoreSpotlight
import SwiftUI

@main
struct VerbsApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    private let router = AppRouter.shared
    private let deeplinkService = DeeplinkService(router: AppRouter.shared)

    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    guard let host = url.host else { return }
                    
                    deeplinkService.handle(host)
                }
                .onContinueUserActivity(CSSearchableItemActionType) { activity in
                    guard let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String
                    else { return }
                    
                    deeplinkService.handle(String(identifier.split(separator: ".").last ?? ""))
                }
                .onContinueUserActivity(CSQueryContinuationActionType) { activity in
                    guard let text = activity.userInfo?[CSSearchQueryString] as? String else { return }
                    
                    deeplinkService.search(text: text)
                }
        }
        .commands { VerbsCommands() }
    }
}
