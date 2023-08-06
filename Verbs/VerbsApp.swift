import SwiftUI

@main
struct VerbsApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    var body: some Scene {
        WindowGroup {
            SplitView()
        }
    }
}
