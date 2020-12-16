//
//  VerbsUpdater.swift
//  Verbs
//
//  Created by Oleg Samoylov on 16.12.2020.
//  Copyright © 2020 Oleg Samoylov. All rights reserved.
//

import WidgetKit

final class VerbsUpdater {
    
    static func reloadWidget() {
        WidgetCenter.shared.getCurrentConfigurations {
            guard case .success(let widgets) = $0,
                  let widget = widgets.first(where: VerbsUpdater.isRightIntent) else { return }
            WidgetCenter.shared.reloadTimelines(ofKind: widget.kind)
        }
    }
    
    private static func isRightIntent(widgetInfo: WidgetInfo) -> Bool {
        let intent = widgetInfo.configuration as? VerbsIntentIntent
        return intent?.displayOption == .favorites
    }
}
