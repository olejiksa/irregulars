//
//  SidebarAssembly.swift
//  Verbs
//
//  Created by Oleg Samoylov on 08.11.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import UIKit

final class SidebarAssembly: AssemblyProtocol {
    
    func viewController() -> some SidebarViewController {
        SidebarViewController(viewModel: SidebarViewModel())
    }
}
