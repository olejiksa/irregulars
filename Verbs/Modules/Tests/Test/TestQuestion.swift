//
//  TestQuestion.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import Foundation

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
final class InputField: ObservableObject, Identifiable {
    
    let id: Int
    let words: [Word]
    /// The word is played rather than shown, so the row offers a play button.
    let isAudio: Bool
    let isLast: Bool
    
    @Published var text = ""
    @Published private(set) var isSubmitted = false
    @Published private(set) var isPlaying = false
    
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

/// A word the reader says out loud, then plays back against the original.
@MainActor
final class RecordField: ObservableObject, Identifiable {
    
    let id: String
    let word: Word
    
    @Published private(set) var isPlaying = false
    @Published private(set) var isRecording = false
    @Published private(set) var isComparing = false
    @Published private(set) var hasRecording = false
    
    init(word: Word, tag: Int, index: Int) {
        id = "\(tag)-\(index)-\(word.value)"
        self.word = word
    }
    
    func setPlaying(_ isPlaying: Bool) {
        self.isPlaying = isPlaying
    }
    
    func setRecording(_ isRecording: Bool) {
        self.isRecording = isRecording
        
        guard !isRecording else { return }
        
        hasRecording = true
    }
    
    func setComparing(_ isComparing: Bool) {
        self.isComparing = isComparing
    }
}
