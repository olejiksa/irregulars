//
//  SystemIcon.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.10.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

enum SystemIcon: String {
    case puzzle = "puzzlepiece"
    case puzzleFill = "puzzlepiece.fill"
    case gear = "gearshape"
    case gearFill = "gearshape.fill"
    case star
    case folder
    case eye
    case ear
    case key
    case globe
    case headphones
    case tortoise = "tortoise.fill"
    case hare = "hare.fill"
    case studentdesk
    case graduationcap = "graduationcap.fill"
    case paintpalette
    case note = "note.text"
    case starFill = "star.fill"
    case speaker = "speaker.wave.3.fill"
    case mic = "mic.fill"
    case transcription = "textformat.abc.dottedunderline"
    case search = "magnifyingglass"
    case alphabet = "list.triangle"
    case dictionary = "a.book.closed.fill"
    case book = "book"
    case bookFill = "book.fill"
    case info = "info.circle"
    case upgrade = "arrow.uturn.up"
    case forms = "textformat.123"
    case letters = "textformat.abc"
    case sentences = "scroll"
    case mouth = "mouth.fill"
    case chart = "chart.bar.xaxis"
    case question = "questionmark.circle"
    case play = "play.circle"
    case stop = "stop.circle"
    case pencil = "pencil.and.outline"
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
