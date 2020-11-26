//
//  AssemblyProtocol.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol AssemblyProtocol {
    
    associatedtype ViewController: UIViewController
    func viewController() -> ViewController
}
