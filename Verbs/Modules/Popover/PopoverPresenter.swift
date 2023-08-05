//
//  PopoverPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 10.01.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class PopoverPresenter: NSObject {
    
    let dataSource = SectionDataSource()
    weak var viewController: PopoverViewController?
    
    override init() {
        super.init()
        setupItems()
    }
}

// MARK: - Private

private extension PopoverPresenter {
    
    func setupItems() {
        dataSource.setup(
            [setupPlaybackSpeedSection(playbackSpeedBlock: didPlaybackSpeedChange)]
        )
    }
    
    func setupPlaybackSpeedSection(playbackSpeedBlock: @escaping IntBlock) -> TableViewSection {
        let index = UserDefaults.shared.integer(for: .playbackSpeed)
        return .init(header: "speaking_rate".localized,
                     items: [SliderItem(leadingIcon: .tortoise,
                                        leadingAccessibilityText: "slower".localized,
                                        trailingIcon: .hare,
                                        trailingAccessibilityText: "faster".localized,
                                        steps: 5,
                                        index: index,
                                        playbackSpeedBlock: playbackSpeedBlock)])
    }
    
    func didPlaybackSpeedChange(_ value: Int) {
        UserDefaults.shared.set(value, for: .playbackSpeed)
    }
}

// MARK: - UITableViewDelegate

extension PopoverPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
