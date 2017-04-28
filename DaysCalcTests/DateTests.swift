//
//  DateTests.swift
//  DaysCalc
//
//  Created by andrei shender on 4/28/17.
//  Copyright © 2017 MoveForward. All rights reserved.
//

import XCTest

class DateTests: XCTestCase {

    func testYearsComparations() {
        let lower = Date(year: 1, month: .oct, day: 3)
        let higher = Date(year: 2, month: .oct, day: 3)
        XCTAssert(lower < higher, "Should compare years properly")
    }

    func testMonthComparations() {
        let lower = Date(year: 1, month: .oct, day: 3)
        let higher = Date(year: 1, month: .nov, day: 3)
        XCTAssert(lower < higher, "Should compare month properly")
    }

    func testDaysComparations() {
        let lower = Date(year: 1, month: .oct, day: 3)
        let higher = Date(year: 1, month: .oct, day: 4)
        XCTAssert(lower < higher, "Should compare month properly")
    }

    func testEquality() {
        let lower = Date(year: 1, month: .oct, day: 3)
        let higher = Date(year: 1, month: .oct, day: 3)
        XCTAssert(lower == higher, "Should be equal")
    }
}
