//
//  VoiceAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import SwiftUI

final class VoiceAssembly {
    
    var viewController: UIHostingController<VoiceView> {
        let view = VoiceView()
        let viewController = UIHostingController(rootView: view)
        viewController.title = String.localized(.voice)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }
}
