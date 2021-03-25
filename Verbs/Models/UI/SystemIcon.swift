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
    case creditcard
    case key
    case globe
    case headphones
    case ellipsis = "ellipsis.circle"
    case tortoise = "tortoise.fill"
    case hare = "hare.fill"
    case paintpalette
    case note = "note.text"
    case starFill = "star.fill"
    case speaker = "speaker.wave.3.fill"
    case transcription = "textformat.abc.dottedunderline"
    case search = "magnifyingglass"
    case listBullet = "list.bullet"
    case listStar = "list.star"
    case book = "book"
    case bookFill = "book.fill"
    case sentences = "scroll"
    case chart = "chart.bar.xaxis"
    case pieChart = "chart.pie"
    case play = "play.circle"
    case stop = "stop.circle"
    case pencil = "pencil.and.outline"
    case twentyFive = "25.circle"
    case printer
    case sunrise
    case sunset = "moon.zzz"
    case skip = "shuffle.circle"
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
