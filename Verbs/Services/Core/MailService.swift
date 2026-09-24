//
//  MailService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 18.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation
import UIKit

@MainActor
final class MailService {
    
    private var url: URL? {
        guard let productName = Bundle.main.productName,
              let version = Bundle.main.releaseVersionNumber else { return nil }
        let subject = "\(productName) \(version)"
        let queryItems = [URLQueryItem(name: "subject", value: subject)]
        var urlComponents = URLComponents(string: "mailto:quillaur@outlook.com")
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
    
    var isMailAvailable: Bool {
        url.map(UIApplication.shared.canOpenURL) ?? false
    }
    
    func present() {
        guard let url else { return }
        UIApplication.shared.open(url)
    }
}
