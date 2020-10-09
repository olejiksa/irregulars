//
//  SplitViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        preferredPrimaryColumnWidthFraction = 0.5
        maximumPrimaryColumnWidth = 2_000
    }
}

// MARK: - UISplitViewControllerDelegate

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        true
    }
}
