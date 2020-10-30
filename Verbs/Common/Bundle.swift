//
//  Bundle.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

extension Bundle {
    
    var productName: String? { infoDictionary?["CFBundleDisplayName"] as? String }
    var releaseVersionNumber: String? { infoDictionary?["CFBundleShortVersionString"] as? String }
}
