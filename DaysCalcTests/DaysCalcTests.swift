//
//  DaysCalcTests.swift
//  DaysCalcTests
//
//  Created by andrei shender on 4/28/17.
//  Copyright © 2017 MoveForward. All rights reserved.
//

import XCTest

@testable import DaysCalc

class DaysCalcTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func shouldError(result: Result) {
        switch result {
        case .failure(let error):
            XCTAssertEqual(error, DaysCalcError.outOfIntervalError)
        default:
            XCTFail()
        }
    }

    func testDateValidLowerInterval() {
        let start = Date(year: 1, month: .apr, day: 1)
        let end = Date(year:9999, month: .may, day: 2)
        let result = DateUtils.daysBetween(start: start, end: end)
        shouldError(result: result)
    }

    func testDateValidHigherInterval() {
        let start = Date(year: 1999, month: .apr, day: 1)
        let end = Date(year:9999, month: .may, day: 2)
        let result = DateUtils.daysBetween(start: start, end: end)
        shouldError(result: result)
    }

    func testIsLeap() {
        XCTAssertTrue(DateUtils.isLeapYear(year: 1600))
        XCTAssertTrue(DateUtils.isLeapYear(year: 2000))
        XCTAssertFalse(DateUtils.isLeapYear(year: 1700))
        XCTAssertFalse(DateUtils.isLeapYear(year: 1900))
        XCTAssertFalse(DateUtils.isLeapYear(year: 2017))
    }

    func testDaysByTheEndOfTheYear() {
        let date = Date(year: 1700, month: .dec, day: 30)
        let days = DateUtils.daysByTheEndOfYear(date: date)
        XCTAssert(days == 1)
    }

    func testDaysByTheEndOfTheYearLeap() {
        let date = Date(year: 1600, month: .jan, day: 30)
        let days = DateUtils.daysByTheEndOfYear(date: date)
        XCTAssert(days == 336)
    }

    func testDaysByTheEndOfTheMonth() {
        let date = Date(year: 2016, month: .feb, day: 28)
        let days = DateUtils.daysByTheEndOfMonth(date: date)
        XCTAssert(days == 1)
    }

    func testDaysInLeapYearFeb() {
        let date = Date(year: 2017, month: .apr, day: 28)
        let days = DateUtils.daysByTheEndOfMonth(date: date)
        XCTAssert(days == 2)
    }

    func testLeapYearsBetween() {
        let years = DateUtils.numberOfLeapYearsBetween(start: 1599, end: 1605)
        XCTAssert(years == 2)
    }

    func testDaysBetweenYears() {
        let days = DateUtils.daysBetweenYears(start: 1803, end: 1841)
        XCTAssert(days == 13515)
    }

    func test0DaysFromBeginningOfYear() {
        let days = DateUtils.daysFromBeginningOfYear(date: Date(year: 2017, month: .jan, day: 1))
        XCTAssert(days == 0)
    }

    func testDaysFromBeginningOfYear() {
        let days = DateUtils.daysFromBeginningOfYear(date: Date(year: 2016, month: .mar, day: 1))
        XCTAssert(days == 60)
    }

    func assertDays(result: Result, expected: UInt) {
        switch result {
        case .success(let daysCalculated):
            XCTAssert(expected == daysCalculated)
        default:
            XCTFail()
        }

    }

    func testDaysBetween() {
        let result19 = DateUtils.daysBetween(start: Date(year: 1983, month: .jun, day: 2), end: Date(year: 1983, month: .jun, day: 22))
        assertDays(result: result19, expected: 19)
        let result173 = DateUtils.daysBetween(start: Date(year: 1984, month: .jul, day: 4), end: Date(year: 1984, month: .dec, day: 25))
        assertDays(result: result173, expected: 173)
        let result1979 = DateUtils.daysBetween(start: Date(year: 1989, month: .jan, day: 3), end: Date(year: 1983, month: .aug, day: 3))
        assertDays(result: result1979, expected: 1979)
        let resultEqual = DateUtils.daysBetween(start: Date(year: 1989, month: .jan, day: 3), end: Date(year: 1989, month: .jan, day: 3))
        assertDays(result: resultEqual, expected: 0)
        let result0 = DateUtils.daysBetween(start: Date(year: 1989, month: .jan, day: 3), end: Date(year: 1989, month: .jan, day: 4))
        assertDays(result: result0, expected: 0)
        let resultReversed = DateUtils.daysBetween(start: Date(year: 1989, month: .jan, day: 3), end: Date(year: 1989, month: .jan, day: 2))
        assertDays(result: resultReversed, expected: 0)
        let result29Feb = DateUtils.daysBetween(start: Date(year: 2016, month: .feb, day: 29), end: Date(year: 2016, month: .mar, day: 2))
        assertDays(result: result29Feb, expected: 1)
        let result28Feb = DateUtils.daysBetween(start: Date(year: 2016, month: .feb, day: 28), end: Date(year: 2016, month: .mar, day: 2))
        assertDays(result: result28Feb, expected: 2)
        let resultLong = DateUtils.daysBetween(start: Date(year: 1901, month: .mar, day: 15), end: Date(year: 2001, month: .aug, day: 30))
        assertDays(result: resultLong, expected: 36692)
    }


    func assertInvalidDateResult(result: Result) {
        switch result {
        case .success( _):
            XCTFail()
        case .failure(let error):
            XCTAssert(error == .nonexistentDate)
        }
    }

    func testNonExistentDates() {
        let invalidStartDate = Date(year: 2017, month: .jun, day: 31)
        let endDate = Date(year: 2017, month: .feb, day: 28)
        let startDate = Date(year: 2017, month: .may, day: 1)
        let invalidEndDate = Date(year: 2017, month: .feb, day: 29)
        assertInvalidDateResult(result: DateUtils.daysBetween(start: invalidStartDate, end: endDate))
        assertInvalidDateResult(result: DateUtils.daysBetween(start: startDate, end: invalidEndDate))
    }
}
