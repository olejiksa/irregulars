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
              current != appIcon else { return }
        
        UIApplication.shared.setAlternateIconName(appIcon.name)
    }
}
