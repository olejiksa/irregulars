//
//  TestSessionView.swift
//  Verbs
//
//  Created by Oleg Samoylov on 24.09.2026.
//  Copyright © 2026 Oleg Samoylov. All rights reserved.
//

import SwiftUI

struct TestSessionView: View {
    
    @Bindable var viewModel: TestSessionViewModel
    
    @FocusState private var focusedField: Int?
    
    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section {
                    ForEach(section.rows) { row in
                        view(for: row)
                    }
                } header: {
                    if let header = section.header {
                        Text(verbatim: header)
                    }
                }
            }
        }
        .animation(.default, value: viewModel.questionToken)
        .alert("hint", isPresented: hintBinding) {
            Button("ok", role: .cancel) {}
        } message: {
            Text(verbatim: viewModel.hint ?? "")
        }
        .navigationTitle(viewModel.test.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.skip()
                } label: {
                    SystemIcon.skip.imageSwiftUI
                }
                .accessibilityLabel("skip".localized)
            }
            
            if [Test.listening, Test.speaking].contains(viewModel.test) {
                ToolbarSpacer(.fixed, placement: .topBarTrailing)
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.isShowingPlaybackSpeed = true
                    } label: {
                        SystemIcon.ellipsis.imageSwiftUI
                    }
                    .popover(isPresented: $viewModel.isShowingPlaybackSpeed) {
                        PopoverView()
                            .presentationCompactAdaptation(.popover)
                    }
                }
            }
        }
    }
}

// MARK: - Rows

private extension TestSessionView {
    
    var hintBinding: Binding<Bool> {
        .init(get: { viewModel.hint != nil },
              set: { if !$0 { viewModel.hint = nil } })
    }
    
    @ViewBuilder
    func view(for row: TestRow) -> some View {
        switch row {
        case .plain(let plain):
            plainRow(plain)
        case .answer(let answer):
            answerRow(answer)
        case .action(let action):
            actionRow(action)
        case .input(let field):
            InputRow(field: field, viewModel: viewModel, focusedField: $focusedField, onSubmit: advance)
        case .record(let field):
            RecordRow(field: field, viewModel: viewModel)
        }
    }
    
    func plainRow(_ row: PlainRow) -> some View {
        Text(verbatim: row.text)
            .foregroundStyle(row.isSecondary ? .secondary : .primary)
            .accessibilityLabel(row.text.replacingOccurrences(of: "…",
                                                              with: ", \("missed_word".localized), "))
    }
    
    @ViewBuilder
    func answerRow(_ row: AnswerRow) -> some View {
        let isAnswered = viewModel.answeredIDs.contains(row.id)
        
        Button {
            viewModel.select(row)
        } label: {
            HStack {
                Text(verbatim: row.text)
                    .strikethrough(isAnswered && !row.isCorrect)
                    .foregroundStyle(isAnswered && row.isCorrect ? Color.accentColor : .primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .contentShape(Rectangle())
        }
        .accessibilityLabel(isAnswered && !row.isCorrect
                            ? "\(row.text), \("wrong_answer".localized)"
                            : row.text)
    }
    
    func actionRow(_ row: ActionRow) -> some View {
        Button(row.title) {
            viewModel.openSettings()
        }
    }
    
    /// Moves on to the next field still waiting for an answer, or closes the keyboard.
    func advance(from field: InputField) {
        let pending = viewModel.sections
            .flatMap(\.rows)
            .compactMap { row -> InputField? in
                guard case .input(let candidate) = row else { return nil }
                return candidate
            }
            .first { $0.id > field.id && !$0.isSubmitted }
        
        focusedField = pending?.id
    }
}

// MARK: - Input

private struct InputRow: View {
    
    @Bindable var field: InputField
    let viewModel: TestSessionViewModel
    var focusedField: FocusState<Int?>.Binding
    let onSubmit: (InputField) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            if field.isAudio {
                Button {
                    viewModel.play(field)
                } label: {
                    (field.isPlaying ? SystemIcon.stop : SystemIcon.play).imageSwiftUI?
                        .font(.title2)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("speak".localized)
            }
            
            if field.isSubmitted && !field.isValid {
                HStack(spacing: 6) {
                    Text(verbatim: field.expected.randomElement() ?? "")
                    Text(verbatim: field.text)
                        .strikethrough()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel("\(field.expected.first ?? ""), \(field.text), \("wrong_answer".localized)")
            } else {
                TextField("enter_here", text: $field.text)
                    .focused(focusedField, equals: field.id)
                    .disabled(field.isSubmitted)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(field.isLast ? .done : .next)
                    .onSubmit {
                        viewModel.submit(field)
                        onSubmit(field)
                    }
            }
            
            if !field.isSubmitted {
                Button {
                    viewModel.showHint(for: field)
                } label: {
                    SystemIcon.key.imageSwiftUI?
                        .font(.title3)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("hint".localized)
            }
        }
    }
}

// MARK: - Record

private struct RecordRow: View {
    
    @Bindable var field: RecordField
    let viewModel: TestSessionViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: field.word.value)
                Text(verbatim: field.word.transcription)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
            
            Spacer()
            
            button(icon: field.isPlaying ? .stop : .play, label: "speak".localized) {
                viewModel.play(field)
            }
            
            // The original cells left these two unlabelled, and there are no
            // translations to borrow, so they stay that way rather than reading a key aloud.
            button(icon: field.isRecording ? .stopRecord : .record,
                   isEnabled: viewModel.isMicrophoneAvailable) {
                viewModel.record(field)
            }
            
            button(icon: field.isComparing ? .stopCompare : .compare,
                   isEnabled: field.hasRecording) {
                viewModel.compare(field)
            }
        }
    }
    
    @ViewBuilder
    private func button(icon: SystemIcon,
                        label: String? = nil,
                        isEnabled: Bool = true,
                        action: @escaping () -> Void) -> some View {
        let button = Button(action: action) {
            icon.imageSwiftUI?.font(.title2)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        
        if let label = label {
            button.accessibilityLabel(label)
        } else {
            button
        }
    }
}
