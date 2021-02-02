//
//  PerformanceTests.swift
//  VerbsUITests
//
//  Created by Oleg Samoylov on 02.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import XCTest

final class PerformanceTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

