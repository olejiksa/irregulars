import SwiftUI

@main
struct VerbsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    var body: some Scene {
        WindowGroup {
            Split()
        }
        
#if os(macOS)
        Settings {
            SettingsMacView()
        }
#endif
    }
}
