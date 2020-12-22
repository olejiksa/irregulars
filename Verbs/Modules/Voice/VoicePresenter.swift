//
//  VoicePresenter.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class VoicePresenter: NSObject {
    
    let dataSource = SelectableSectionDataSource()
    var router: VoiceRouter?
    weak var viewController: VoiceViewController?
    
    private let voiceService: VoiceService
    
    init(voiceService: VoiceService) {
        self.voiceService = voiceService
        super.init()
        setupSections()
    }
}

// MARK: - Private

private extension VoicePresenter {
    
    func setupSections() {
        let sections = Gender.allCases.map { gender in
            Section(header: gender.description,
                    items: voiceService.voices(gender: gender)
                        .sorted { $0.name < $1.name }
                        .map { voice in
                            let region = Region(rawValue: String(voice.language.suffix(2)))
                            return VoiceItem(name: voice.name,
                                             voiceID: voice.identifier,
                                             gender: gender,
                                             region: region ?? .unitedStates) }
            )
        }
        
        let hintSection = Section(items: [PlainDetailItem(text: "voice_hint".localized, textStyle: .secondary)])
        dataSource.setup(sections + [hintSection])
        
        let iterativeSections = sections.filter { !$0.items.isEmpty }
        
        let voiceID = UserDefaults.shared.string(for: .voice)
        for sectionIndex in 0..<iterativeSections.count {
            if let items = iterativeSections[safe: sectionIndex]?.items as? [VoiceItem],
               let index = items.firstIndex(where: { $0.voiceID == voiceID }) {
                let indexPath = IndexPath(row: index, section: sectionIndex)
                dataSource.selectedIndexPath = indexPath
                return
            }
        }
        
        for sectionIndex in 0..<iterativeSections.count {
            if let items = iterativeSections[safe: sectionIndex]?.items as? [VoiceItem],
               let index = items.firstIndex(where: { $0.gender == Gender.current && $0.region == Region.current }) {
                let indexPath = IndexPath(row: index, section: sectionIndex)
                dataSource.selectedIndexPath = indexPath
                return
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension VoicePresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard dataSource.selectedIndexPath != indexPath else {
            return
        }
        
        guard FeatureToggle.isPaid else {
            router?.goToPaywall()
            return
        }
        
        guard let item = dataSource.item(at: indexPath) as? VoiceItem else { return }
        dataSource.selectedIndexPath = indexPath
        
        Gender.current = item.gender
        Region.current = item.region
        UserDefaults.shared.set(item.voiceID, for: .voice)
        NotificationCenter.default.post(name: .reload, object: nil)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard FeatureToggle.isPaid, dataSource.item(at: indexPath) is VoiceItem else { return indexPath }
        
        if let oldIndex = dataSource.selectedIndexPath {
            tableView.cellForRow(at: oldIndex)?.accessoryType = .none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        return indexPath
    }
}

