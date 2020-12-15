//
//  IntentHandler.swift
//  VerbsWidgetIntent
//
//  Created by Oleg Samoylov on 15.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import Intents

final class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
}
