//
//  SystemIcon.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

enum SystemIcon: String {
    case gear
    case star
    case starFill = "star.fill"
    case speaker = "speaker.wave.3.fill"
    case transcription = "textformat.abc.dottedunderline"
    case search = "magnifyingglass"
    case alphabet = "list.triangle"
    case widget = "note.text"
    case toggle = "switch.2"
    case dictionary = "a.book.closed.fill"
    case book = "book"
    case bookFill = "book.fill"
    case info = "info.circle"
    case upgrade = "arrow.uturn.up"
    case forms = "textformat.123"
    case letters = "textformat.abc"
    case sentences = "rectangle.and.pencil.and.ellipsis"
    case pronunciation = "mouth"
    case chart = "chart.pie"
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
