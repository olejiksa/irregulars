//import SwiftUI
//
//@main
//struct VerbsApp: App {
//
//    @UIApplicationDelegateAdaptor(AppDelegate.self)
//    private var appDelegate
//
//    @StateObject
//    private var purchaseService: PurchaseService
//
//    init() {
//        let purchaseService = Locator.purchaseService
//        _purchaseService = StateObject(wrappedValue: purchaseService)
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            Split()
//                .task {
//                    do {
//                        await purchaseService.updatePurchasedProducts()
//                        try await purchaseService.loadProducts()
//                    } catch {
//                        print(error)
//                    }
//                }
//        }
//    }
//}
