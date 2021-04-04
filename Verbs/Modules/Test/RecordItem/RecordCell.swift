//
//  RecordCell.swift
//  Verbs
//
//  Created by Oleg Samoylov on 01.04.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import UIKit

final class RecordCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var transcriptionLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var compareButton: UIButton!
    
    private weak var item: RecordItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        playButton.set(icon: .play)
        recordButton.set(icon: .record)
    }
}

// MARK: - Private

private extension RecordCell {
    
    @IBAction func didPlayTap() {
        guard let text = item?.word.value else { return }
        item?.playActionBlock?(text, play, stopPlay)
    }
    
    @IBAction func didRecordTap() {
        item?.recordActionBlock?(record, stopRecord)
    }
    
    @IBAction func didCompareTap() {
        item?.compareActionBlock?(compare, stopCompare)
    }
    
    func play() {
        playButton.set(icon: .stop)
    }
    
    func stopPlay() {
        playButton.set(icon: .play)
    }
    
    func record() {
        recordButton.set(icon: .stopRecord)
    }
    
    func stopRecord() {
        recordButton.set(icon: .record)
        compareButton.isEnabled = true
    }
    
    func compare() {
        compareButton.set(icon: .stopCompare)
    }
    
    func stopCompare() {
        compareButton.set(icon: .compare)
    }
}

// MARK: - CellProtocol

extension RecordCell: CellProtocol {
    
    static var identifier: String { "\(RecordCell.self)" }
    
    func setup(with item: ItemProtocol) {
        guard let item = item as? RecordItem else { return }
        
        self.item = item
        
        titleLabel?.text = item.word.value
        transcriptionLabel?.text = item.word.transcription
    }
}
