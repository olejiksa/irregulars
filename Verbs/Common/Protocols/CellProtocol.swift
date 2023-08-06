//
//  CellProtocol.swift
//  Verbs
//
//  Created by Oleg Samoylov on 28.09.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

protocol CellProtocol {
    
    static var identifier: String { get }
    
    func setup(with: ItemProtocol)
}
