//
//  CalendarTests.swift
//  VerbsTests
//
//  Created by Oleg Samoylov on 18.02.2021.
//  Copyright © 2021 Oleg Samoylov. All rights reserved.
//

import XCTest
@testable import Irregulars

final class CalendarTests: XCTestCase {
    
    private var dateFormatter: ISO8601DateFormatter!
    private var sut: CalendarService!

    override func setUp() {
        dateFormatter = ISO8601DateFormatter()
        sut = .init()
    }
    
    override func tearDown() {
        dateFormatter = nil
        sut = nil
    }
    
    func testFiveDates() throws {
        // arrange
        let count = 5
        let startDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T09:00:00+0000"))
        let endDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T21:00:00+0000"))
        
        // act
        let dates = sut.schedule(count: count, startDate: startDate, endDate: endDate)
        
        // assert
        XCTAssertEqual(dates.count, 5)
        XCTAssertEqual(dates, dates.sorted())
    }
    
    func testOppositeFiveDates() throws {
        // arrange
        let count = 5
        let startDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T21:00:00+0000"))
        let endDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T09:00:00+0000"))
        
        // act
        let dates = sut.schedule(count: count, startDate: startDate, endDate: endDate)
        
        // assert
        XCTAssertEqual(dates.count, 5)
        XCTAssertEqual(dates, dates.sorted())
    }
    
    func testOneDate() throws {
        // arrange
        let count = 1
        let startDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T09:00:00+0000"))
        let endDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T18:00:00+0000"))
        
        // act
        let dates = sut.schedule(count: count, startDate: startDate, endDate: endDate)
        
        // assert
        XCTAssertEqual(dates.count, 1)
        XCTAssertEqual(dates.first, startDate)
    }
    
    func testTwoDates() throws {
        // arrange
        let count = 2
        let startDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T09:00:00+0000"))
        let endDate = try XCTUnwrap(dateFormatter.date(from: "2021-02-17T18:00:00+0000"))
        
        // act
        let dates = sut.schedule(count: count, startDate: startDate, endDate: endDate)
        
        // assert
        XCTAssertEqual(dates.count, 2)
        XCTAssertEqual(dates, dates.sorted())
        XCTAssertEqual(dates.first, startDate)
        XCTAssertEqual(dates.last, endDate)
    }
}
