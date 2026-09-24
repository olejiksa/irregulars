//
//  PopoverHostingController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI
import UIKit

/// Hosts `PopoverView` so that the UIKit screens can present it as a popover.
final class PopoverHostingController: UIHostingController<PopoverView> {
    
    init() {
        super.init(rootView: PopoverView())
        
        sizingOptions = [.preferredContentSize]
        modalPresentationStyle = .popover
    }
    
    @MainActor required dynamic init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension PopoverHostingController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}

extension UIViewController {
    
    /// Presents the playback speed popover anchored to the given bar button item.
    func presentPlaybackSpeedPopover(from sender: UIBarButtonItem) {
        let viewController = PopoverHostingController()
        viewController.popoverPresentationController?.barButtonItem = sender
        viewController.popoverPresentationController?.delegate = viewController
        present(viewController, animated: true)
    }
}
