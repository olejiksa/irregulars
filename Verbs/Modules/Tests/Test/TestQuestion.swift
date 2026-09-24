//
//  TestQuestion.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation
import Observation

struct TestSection: Identifiable {
    
    let id: Int
    let header: String?
    let rows: [TestRow]
}

enum TestRow: Identifiable {
    
    case plain(PlainRow)
    case answer(AnswerRow)
    case action(ActionRow)
    case input(InputField)
    case record(RecordField)
    
    var id: String {
        switch self {
        case .plain(let row):
            return "plain-\(row.id)"
        case .answer(let row):
            return "answer-\(row.id)"
        case .action(let row):
            return "action-\(row.id)"
        case .input(let field):
            return "input-\(field.id)"
        case .record(let field):
            return "record-\(field.id)"
        }
    }
}

struct PlainRow: Identifiable {
    
    let id: String
    let text: String
    let isSecondary: Bool
}

struct AnswerRow: Identifiable, Hashable {
    
    let id: String
    let text: String
    let isCorrect: Bool
}

struct ActionRow: Identifiable {
    
    let id: String
    let title: String
}

/// A word the reader types in. Holds the state the row edits, so the view model can
/// ask whether every field of the question has been answered.
@MainActor
@Observable
final class InputField: Identifiable {
    
    let id: Int
    let words: [Word]
    /// The word is played rather than shown, so the row offers a play button.
    let isAudio: Bool
    let isLast: Bool
    
    var text = ""
    private(set) var isSubmitted = false
    private(set) var isPlaying = false
    
    private(set) var isValid = false
    
    var expected: [String] { words.map(\.value) }
    
    init(id: Int, words: [Word], isAudio: Bool, isLast: Bool) {
        self.id = id
        self.words = words
        self.isAudio = isAudio
        self.isLast = isLast
    }
    
    func submit() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isSubmitted else { return }
        
        isValid = expected.contains { $0.lowercased() == trimmed.lowercased() }
        isSubmitted = true
    }
    
    func setPlaying(_ isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
}

/// A word the reader says out loud for the recogniser to check.
@MainActor
@Observable
final class RecordField: Identifiable {
    
    enum Verdict: Equatable {
        case correct
        case wrong
    }
    
    let id: String
    let word: Word
    
    private(set) var isPlaying = false
    private(set) var isListening = false
    
    /// What came back, kept even when it was wrong so the reader can see why.
    private(set) var heard: String?
    private(set) var verdict: Verdict?
    
    init(word: Word, tag: Int, index: Int) {
        id = "\(tag)-\(index)-\(word.value)"
        self.word = word
    }
    
    func setPlaying(_ isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
    
    /// Starting over clears the last answer, so a second try begins from nothing.
    func setListening(_ isListening: Bool) {
        self.isListening = isListening
        
        guard isListening else { return }
        
        heard = nil
        verdict = nil
    }
    
    func setHeard(_ heard: String) {
        self.heard = heard
    }
    
    func setVerdict(_ verdict: Verdict) {
        self.verdict = verdict
    }
}
