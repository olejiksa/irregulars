//
//  StoreScreenshotsTests.swift
//  VerbsUITests
//
//  Created by Oleg Samoylov on 02.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import XCTest

final class StoreScreenshotsTests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAListening() {
        app.launchEnvironment = ["accent-color": "yellow"]
        app.launchArguments = ["dark"]
        app.launch()
        
        tapTab(.testsTab)
        
        let cellID = AccessibilityIdentifier.listeningCell.rawValue
        app.cells[cellID].tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "listening")
    }
    
    func testBSentences() {
        app.launchEnvironment = ["accent-color": "blue"]
        app.launch()
        
        tapTab(.testsTab)
        
        let cellID = AccessibilityIdentifier.sentencesCell.rawValue
        app.cells[cellID].tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "sentences")
    }
    
    func testCVoice() {
        app.launchEnvironment = ["accent-color": "teal"]
        app.launchArguments = ["dark"]
        app.launch()
        
        tapTab(.settingsTab)
        
        let cellID = AccessibilityIdentifier.voiceCell.rawValue
        app.cells[cellID].tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "voice")
    }
    
    func testDAccentColor() {
        app.launchEnvironment = ["accent-color": "red"]
        app.launch()
        
        tapTab(.settingsTab)
        
        let cellID = AccessibilityIdentifier.accentColorCell.rawValue
        app.cells[cellID].tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))
        
        let tableID = AccessibilityIdentifier.accentColorTable.rawValue
        let accentColorCell = app.tables[tableID].cells.element(boundBy: 6)
        accentColorCell.tap()
        
        attachScreenshot(name: "accent-color")
    }
    
    func testENotifications() {
        app.launchEnvironment = ["accent-color": "purple"]
        app.launchArguments = ["dark"]
        app.launch()
        
        tapTab(.settingsTab)
        
        let cellID = AccessibilityIdentifier.notificationsCell.rawValue
        app.cells[cellID].tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))
        
        attachScreenshot(name: "notifications")
    }

    func testFStatistics() {
        app.launchEnvironment = ["accent-color": "pink"]
        app.launch()
        
        tapTab(.testsTab)

        let cellID = AccessibilityIdentifier.statisticsCell.rawValue
        app.cells[cellID].tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "statistics")
    }
    
    func testGFavorites() {
        app.launchEnvironment = ["accent-color": "orange"]
        app.launchArguments = ["dark"]
        app.launch()
        
        tapTab(.favoritesTab)
        
        let editButtonID = AccessibilityIdentifier.editButton.rawValue
        let editButton = app.navigationBars.children(matching: .button)[editButtonID]
        XCTAssertTrue(editButton.waitForExistence(timeout: 3))
        
        editButton.tap()
        
        let doneButtonID = AccessibilityIdentifier.doneButton.rawValue
        let doneButton = app.navigationBars.children(matching: .button)[doneButtonID]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "favorites")
    }
    
    func testHVerbDetail() {
        app.launchArguments = ["dark"]
        app.launch()
        
        app.tables.element(boundBy: 0).cells.element(boundBy: 1).tap()
        
        let backBarButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backBarButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "verb-detail")
    }
    
    func testITests() {
        app.launchEnvironment = ["accent-color": "green"]
        app.launchArguments = ["dark"]
        app.launch()
        
        tapTab(.testsTab)
        
        let barButton = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(barButton.waitForExistence(timeout: 3))

        attachScreenshot(name: "sentences")
    }
    
    func testJAllVerbs() {
        app.launchEnvironment = ["accent-color": "blue"]
        app.launch()

        attachScreenshot(name: "all-verbs")
    }
}

// MARK: - Private

private extension StoreScreenshotsTests {
    
    func tapTab(_ identifier: AccessibilityIdentifier) {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            app.collectionViews.cells[identifier.rawValue].tap()
        case .phone:
            app.buttons[identifier.rawValue].tap()
        default:
            break
        }
    }
    
    func attachScreenshot(name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
