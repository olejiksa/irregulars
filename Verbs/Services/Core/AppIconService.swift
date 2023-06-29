//
//  AppIconService.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class AppIconService {
    
    private var current: AppIcon {
        AppIcon(string: UIApplication.shared.alternateIconName)
    }
    
    func setIcon(for color: AccentColor) {
        let appIcon = AppIcon(color: color)
        
        guard UIApplication.shared.supportsAlternateIcons,
              current != appIcon,
              let name = appIcon.name else { return }
        
        Task { @MainActor in
            do {
                switch color {
                case .blue:
                    try await UIApplication.shared.setAlternateIconName(nil)
                default:
                    try await UIApplication.shared.setAlternateIconName(name)
                }
            } catch {
                print(error)
            }
        }
    }
}
