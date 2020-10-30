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
    case speaker = "speaker.wave.3.fill"
    case transcription = "textformat.abc.dottedunderline"
    case search = "magnifyingglass"
    case alphabet = "list.triangle"
    case widget = "note.text"
    case toggle = "switch.2"
    case dictionary = "a.book.closed.fill"
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
