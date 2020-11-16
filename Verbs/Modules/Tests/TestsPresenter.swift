//
//  TestsPresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 29.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class TestsPresenter: NSObject {
    
    weak var viewController: UIViewController?
    
    let dataSource = SectionDataSource()
    
    override init() {
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension TestsPresenter {
    
    func setupSections() {
        let items = [SubtitleItem(title: "Level 1",
                                  subtitle: "go, see, sing, get, take",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 2",
                                  subtitle: "drink, sleep, choose, meet, fly, forget, hang, catch, blow",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 3",
                                  subtitle: "fall, draw, begin, freeze, give, throw, rise, forgive, shine, hold, bite, bring",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 4",
                                  subtitle: "swim, grow, teach, tear, understand, wake, write, think, read, ring, run, leave, seek, sell",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 5",
                                  subtitle: "dig, drive, hide, make, send, shake, shoot, speak, tell, win, beat, bend, cost, have, be",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 6",
                                  subtitle: "burn, become, eat, fight, hear, hit, keep, light, mean, ride, say, swing, show, wear, lay",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 7",
                                  subtitle: "bet, break, build, cut, deal, do, feed, feel, find, hurt, know, lead, lend, let, lie, set",
                                  hasDisclosureIndicator: true),
                     SubtitleItem(title: "Level 8",
                                  subtitle: "put, sweep, strike, stick, steal, stand, spend, sit, sink, shut, pay, come, lose, buy",
                                  hasDisclosureIndicator: true)]
        
        dataSource.setup([Section(header: nil,
                                items: items)])
    }
}

// MARK: - UITableViewDelegate

extension TestsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = TestDetailAssembly(navigationController: viewController?.navigationController).viewController()
        viewController?.navigationController?.push(vc)
    }
}
