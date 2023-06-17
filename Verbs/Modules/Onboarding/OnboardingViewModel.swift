//
//  OnboardingViewModel.swift
//  Verbs
//
//  Created by Oleg Samoylov on 6/17/23.
//  Copyright © 2023 Oleg Samoylov. All rights reserved.
//

import Foundation

final class OnboardingViewModel: ObservableObject {
    
    @Published private(set) var items: [OnboardingItem] = []
    @Published var selection = 0
    
    var isLast: Bool {
        selection == items.count - 1
    }
    
    init() {
        items = [
            .init(id: 0, emoji: "🤗", title: "Привет", content: "Спасибо за загрузку нашего приложения! Давай познакомимся поближе"),
            .init(id: 1, emoji: "🤔", title: "Зачем и почему", content: "Таблица неправильных глаголов в английском — как таблица умножения в математике. Неправильные глаголы появляются уже на ранних этапах обучения языку"),
            .init(id: 2, emoji: "🧐", title: "Представляете?", content: "10 глаголов, которые чаще всего употребляются в речи — неправильные! (be, get, go, say и так далее)"),
            .init(id: 3, emoji: "📖", title: "Три формы глагола", content: """
Чтобы не допускать ошибок в английских временах, необходимо знать три формы глагола:
начальную, или инфинитив,
форму прошедшего времени
и третью форму, или причастие прошедшего времени
"""),
            .init(id: 4, emoji: "📒", title: "Правильные глаголы", content: "2-я и 3-я формы правильных глаголов образуются с помощью окончания -ed: close (закрывать), closed (закрыл), closed (закрыл, закрыт, закрытый)"),
            .init(id: 5, emoji: "📔", title: "Неправильные глаголы", content: "Образование 2-й и 3-й формы у неправильных глаголов нужно запоминать"),
            .init(id: 6, emoji: "🥳", title: "Готовы начинать?", content: "So... Shall we begin/began/begun?")
        ]
    }
}
