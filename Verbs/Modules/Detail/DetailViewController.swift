//
//  DetailViewController.swift
//  Verbs
//
//  Created by Oleg Samoylov on 26.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit
import AVFoundation

final class DetailViewController: UIViewController {

    private let audioService = AudioService()
    private let cellID = "\(DetailCell.self)"
    private let verb: Verb
    private var items: [DetailItem] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    init(verb: Verb) {
        self.verb = verb
        super.init(nibName: nil, bundle: nil)
        self.items = [DetailItem(caption: "Базовая форма",
                                 title: verb.infinitive,
                                 actionBlock: self.playButtonDidTap),
                      DetailItem(caption: "Форма прошедшего времени (2-я)",
                                 title: verb.pastSimple,
                                 actionBlock: self.playButtonDidTap),
                      DetailItem(caption: "Форма причастия прошедшего времени (3-я)",
                                 title: verb.pastParticiple,
                                 actionBlock: self.playButtonDidTap),
                      DetailItem(caption: "Перевод",
                                 title: verb.infinitive,
                                 actionBlock: self.playButtonDidTap)].compactMap { $0 }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }
}

// MARK: - Private

private extension DetailViewController {
    
    func setupNavigationBar() {
        navigationItem.title = verb.infinitive
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView() {
        let nib = UINib(nibName: cellID, bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: cellID)
    }
    
    func playButtonDidTap(text: String) {
        audioService.play(text: text)
    }
}

// MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                     for: indexPath) as? DetailCell
        else {
            return .init(frame: .zero)
        }
        
        cell.setup(item: items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
