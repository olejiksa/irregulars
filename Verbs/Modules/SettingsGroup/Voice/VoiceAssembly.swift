//
//  VoiceAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 21.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

final class VoiceAssembly: AssemblyProtocol {
    
    func viewController() -> some VoiceViewController {
        let voiceService = VoiceService()
        let audioService = AudioService(voiceService: voiceService)
        let presenter = VoicePresenter(audioService: audioService, voiceService: voiceService)
        let viewConroller = VoiceViewController(presenter: presenter)
        let router = VoiceRouter(viewController: viewConroller)
        presenter.viewController = viewConroller
        presenter.router = router
        return viewConroller
    }
}
