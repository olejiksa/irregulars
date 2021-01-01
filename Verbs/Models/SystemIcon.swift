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
    case starSlash = "star.slash"
    case folder
    case eye
    case ear
    case lock
    case key
    case globe
    case headphones
    case ellipsis = "ellipsis.circle"
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
    case listBullet = "list.bullet"
    case listStar = "list.star"
    case textBook = "text.book.closed"
    case textBookFill = "text.book.closed.fill"
    case aBook = "a.book.closed"
    case aBookFill = "a.book.closed.fill"
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
    case twentyFive = "25.circle"
    case printer
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
