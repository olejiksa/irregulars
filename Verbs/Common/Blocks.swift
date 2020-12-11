//
//  Blocks.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

typealias Block = () -> Void

typealias AudioBlock = (String, @escaping Block, @escaping Block) -> Void
typealias BoolBlock = (Bool) -> Void
typealias IntBlock = (Int) -> Void
typealias ItemBlock = (ItemProtocol) -> Void
typealias StringBlock = (String) -> Void
