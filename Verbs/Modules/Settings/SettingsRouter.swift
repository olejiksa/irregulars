//
//  SettingsRouter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 11.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SafariServices
import UIKit

final class SettingsRouter {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func goToURL(_ url: URL) {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: configuration)
        vc.preferredControlTintColor = AccentColor.current.color
        vc.modalPresentationStyle = .pageSheet
        viewController?.present(vc, animated: true)
    }
    
    func open(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    
    func goToPaywall() {
        let vc = PaywallAssembly().viewController()
        let nvc = UINavigationController(rootViewController: vc)
        nvc.modalPresentationStyle = .formSheet
        viewController?.present(nvc, animated: true)
    }
    
    func goToAccentColor() {
        let vc = AccentColorAssembly().viewController()
        viewController?.navigationController?.push(vc)
    }
    
    func goToVoice() {
        let vc = VoiceAssembly().viewController()
        viewController?.navigationController?.push(vc)
    }
    
    func goToAcknowledgements() {
        let vc = AcknowledgementsAssembly().viewController()
        viewController?.navigationController?.push(vc)
    }
    
    func share(_ url: URL, in view: UIView) {
        let activityViewController = UIActivityViewController(activityItems: [url],
                                                              applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        viewController?.present(activityViewController, animated: true)
    }
}
