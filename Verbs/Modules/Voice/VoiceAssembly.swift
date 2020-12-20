//
//  VoiceAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class VoiceAssembly: AssemblyProtocol {
    
    func viewController() -> some VoiceViewController {
        let presenter = VoicePresenter(voiceService: .init())
        let viewConroller = VoiceViewController(presenter: presenter)
        presenter.viewController = viewConroller
        return viewConroller
    }
}
