//
//  MenuAction.swift
//  Verbs
//
//  Created by Oleg Samoylov on 15.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Foundation

@objc protocol MenuAction {
    
    func cut(_ sender: AnyObject)
    func copy(_ sender: AnyObject)
    func paste(_ sender: AnyObject)
}
