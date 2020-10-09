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
    
    var image: UIImage? { UIImage(systemName: rawValue) }
}
