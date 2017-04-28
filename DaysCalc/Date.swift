//
//  Date.swift
//  DaysCalc
//
//  Created by andrei shender on 4/28/17.
//  Copyright © 2017 MoveForward. All rights reserved.
//

import Cocoa

enum Month: UInt {
    case jan = 0, feb, mar, apr, may, jun, jul, aug, sept, oct, nov, dec
}

class Date : Comparable {
    let year: UInt
    let month: Month
    let day: UInt
    init(year: UInt, month: Month, day: UInt) {
        self.year = year
        self.month = month
        self.day = day
    }

    static func < (lhs: Date, rhs: Date) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month.rawValue < rhs.month.rawValue
        } else {
            return lhs.day < rhs.day
        }
    }

    static func == (lhs: Date, rhs: Date) -> Bool {
        return lhs.year == rhs.year && rhs.month.rawValue == lhs.month.rawValue && lhs.day == rhs.day;
    }
}
