//
//  SplitViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 30.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SplitViewController: UISplitViewController {
    
    private var viewDidLoadCalled = false
    
    init() {
        super.init(style: .tripleColumn)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredBehavior(for: view.bounds.size.width)
    }
    
    private func updatePreferredBehavior(for width: CGFloat) {
        if width >= 1024 {
            preferredDisplayMode = .twoBesideSecondary
            preferredSplitBehavior = .tile
        } else {
            preferredDisplayMode = .oneBesideSecondary
            preferredSplitBehavior = .displace
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updatePreferredBehavior(for: size.width)
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: - UISplitViewControllerDelegate

extension SplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        print("topColumnForCollapsingToProposedTopColumn: \(topColumnForCollapsingToProposedTopColumn.rawValue)")
        return topColumnForCollapsingToProposedTopColumn
    }
    
    func splitViewController( _ svc: UISplitViewController, displayModeForExpandingToProposedDisplayMode proposedDisplayMode: UISplitViewController.DisplayMode) -> UISplitViewController.DisplayMode {
        print("proposedDisplayMode: \(proposedDisplayMode.rawValue)")
        return proposedDisplayMode
    }
}
