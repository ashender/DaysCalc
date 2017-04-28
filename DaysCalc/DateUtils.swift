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

    static fileprivate let daysPerYear: UInt = 365
    static fileprivate let daysPerLeapYear: UInt = 366

    static fileprivate let daysPerMonth:[UInt] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    static func daysBetween(start: Date, end: Date) -> Result {
        if start < minDate || end > maxDate {
            return .failure(.outOfIntervalError)
        }

        if !isDateValid(date: start) || !isDateValid(date: end) {
            return .failure(.nonexistentDate)
        }

        var validatedStart = start
        var validatedEnd = end
        if end < start {
            validatedStart = end
            validatedEnd = start
        }

        let toTheEnd = daysByTheEndOfYear(date: validatedStart)
        let between = daysBetweenYears(start: validatedStart.year, end: validatedEnd.year);
        let fromBeginning = daysFromBeginningOfYear(date: validatedEnd)
        if validatedStart.year == validatedEnd.year {
            return .success(toTheEnd + fromBeginning - daysInYear(year: validatedStart.year))
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
        if date.month == .feb && isLeapYear(year: date.year) {
            numberOfDays += 1
        }
        return numberOfDays
    }

    static func daysByTheEndOfMonth(date: Date) -> UInt {
        return  daysInDateMonth(date:date) - date.day
    }

    static func daysByTheEndOfYear(date: Date) -> UInt {
        let isLeap: Bool = isLeapYear(year: date.year)
        let daysByEndOfMonth = daysByTheEndOfMonth(date: date)
        var days: UInt = daysPerMonth.dropFirst(Int(date.month.rawValue + 1)).reduce(daysByEndOfMonth) { (total, daysInMonth) -> UInt in total + daysInMonth }
        if isLeap && (date.month == .jan) {
            days += 1
        }
        return days
    }

    static func daysBetweenYears(start: UInt, end: UInt) -> UInt {
        if start == end {
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
        var days = daysPerMonth.dropLast(Int(12 - date.month.rawValue)).reduce(date.day - 1, { (total, daysInMonth) -> UInt in total + daysInMonth})
        if isLeapYear(year: date.year) && date.month.rawValue > Month.feb.rawValue {
            days += 1
        }
        return days
    }
}
