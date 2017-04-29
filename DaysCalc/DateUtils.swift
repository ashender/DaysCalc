//
//  DateUtils.swift
//  DaysCalc
//
//  Created by andrei shender on 4/28/17.
//  Copyright © 2017 MoveForward. All rights reserved.
//

import Cocoa

enum Result {
    case failure(DaysCalcError)
    case success(UInt)
}

enum DaysCalcError: Error {
    case outOfIntervalError
    case nonexistentDate
}

class DateUtils: NSObject {

    static fileprivate let minDate = Date(year: 1901, month: .jan, day: 1)
    static fileprivate let maxDate = Date(year: 2999, month: .dec, day: 31)

    static fileprivate let daysPerYear: UInt = 365, daysPerLeapYear: UInt = 366

    static fileprivate let daysPerMonth:[UInt] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    static func daysBetween(start: Date, end: Date) -> Result {
        guard start > minDate && end < maxDate else {
            return .failure(.outOfIntervalError)
        }

        guard isDateValid(date: start) && isDateValid(date: end) else {
            return .failure(.nonexistentDate)
        }

        guard start != end else {
            return .success(0)
        }

        var end = end, start = start
        if end < start {
            swap(&end, &start)
        }

        let toTheEnd = daysByTheEndOfYear(date: start)
        let between = daysBetweenYears(start: start.year, end: end.year);
        let fromBeginning = daysFromBeginningOfYear(date: end)
        if start.year == end.year {
            return .success(toTheEnd + fromBeginning - daysInYear(year: start.year))
        }
        else {
            return .success(toTheEnd + between + fromBeginning)
        }
    }

    static fileprivate func daysInYear(year: UInt) -> UInt {
        return UInt(isLeapYear(year: year) ? daysPerLeapYear : daysPerYear)
    }

    static fileprivate func isDateValid(date: Date) -> Bool {
        return daysInDateMonth(date: date) >= date.day
    }
    
    static func isLeapYear(year: UInt) -> Bool {
        return (year % 4 == 0) && !((year % 100 == 0) && (year % 400 != 0))
    }

    static func daysInDateMonth(date: Date) -> UInt {
        var numberOfDays = daysPerMonth[Int(date.month.rawValue)]
        if date.month == .feb && isLeapYear(year: date.year) { numberOfDays += 1 }
        return numberOfDays
    }

    static func daysByTheEndOfMonth(date: Date) -> UInt {
        return  daysInDateMonth(date:date) - date.day
    }

    static func daysByTheEndOfYear(date: Date) -> UInt {
        let isLeap = isLeapYear(year: date.year)
        let daysByEndOfMonth = daysByTheEndOfMonth(date: date)
        var days: UInt = daysPerMonth.dropFirst(Int(date.month.rawValue + 1)).reduce(daysByEndOfMonth) { $0 + $1 }
        if isLeap && (date.month == .jan) { days += 1 }
        return days
    }

    static func daysBetweenYears(start: UInt, end: UInt) -> UInt {
        guard start != end else {
            return 0
        }

        let yearsInBetween: UInt = (end - start - 1)
        return yearsInBetween * daysPerYear + numberOfLeapYearsBetween(start:start, end:end)
    }

    static func numberOfLeapYearsBetween(start: UInt, end: UInt) -> UInt {
        let end = end - 1
        return (end/4 - end/100 + end/400) - (start/4 - start/100 + start/400)
    }

    static func daysFromBeginningOfYear(date: Date) -> UInt {
        var days = daysPerMonth.dropLast(Int(12 - date.month.rawValue)).reduce(date.day - 1) { $0 + $1 }
        if isLeapYear(year: date.year) && date.month.rawValue > Month.feb.rawValue { days += 1 }
        return days
    }
}
