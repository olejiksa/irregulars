//
//  MailService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import MessageUI

final class MailService: NSObject {
    
    func present(in viewController: UIViewController?) {
        guard
            let productName = Bundle.main.productName,
            let version = Bundle.main.releaseVersionNumber
        else { return }

        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["quillaur@outlook.com"])
        mailComposeViewController.setSubject("\(productName) \(version)")
        
        viewController?.present(mailComposeViewController, animated: true)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension MailService: MFMailComposeViewControllerDelegate {
    
    var isMailAvailable: Bool { MFMailComposeViewController.canSendMail() }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}

private extension Bundle {
    
    var productName: String? { infoDictionary?["CFBundleName"] as? String }
    var releaseVersionNumber: String? { infoDictionary?["CFBundleShortVersionString"] as? String }
}
