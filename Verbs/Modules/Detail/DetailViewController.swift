//
//  DetailViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

    private let audioService = AudioService()
    private let languageService = LanguageService()
    private let verb: Verb
    private let isOpenedByDeeplink: Bool
    private let sections = ["Infinitive, Simple Past, Past Participle",
                            "Translation".localized]
    private var items: [[ItemProtocol]] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    init(verb: Verb, isOpenedByDeeplink: Bool = false) {
        self.verb = verb
        self.isOpenedByDeeplink = isOpenedByDeeplink
        super.init(nibName: nil, bundle: nil)
        setItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
        setupDelegate()
    }
}

// MARK: - Private

private extension DetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = verb.infinitive.value
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView() {
        tableView.register(DetailCell.self, TranslationCell.self)
    }
    
    func setupDelegate() {
        navigationController?.delegate = self
    }
    
    func setItems() {
        items = [[DetailItem(word: verb.infinitive, actionBlock: play),
                  DetailItem(word: verb.simplePast, actionBlock: play),
                  DetailItem(word: verb.pastParticiple, actionBlock: play)].compactMap { $0 }]
        if languageService.hasTranslation {
            items += [[TranslationItem(header: "Translation".localized, text: verb.translation)]]
        }
    }
    
    func play(text: String) {
        audioService.play(text: text)
    }
}

// MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section][indexPath.row]
        return tableView.dequeueReusableCell(for: item, at: indexPath)
    }
}

// MARK: - UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UINavigationControllerDelegate

extension DetailViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        guard animated || isOpenedByDeeplink else { return }
        let title = viewController.navigationItem.title ?? ""
        NotificationCenter.default.post(name: Notification.Name.infinitive,
                                        object: nil,
                                        userInfo: ["infinitive": title])
    }
}
