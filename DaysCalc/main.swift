//
//  main.swift
//  DaysCalc
//
//  Created by andrei shender on 4/28/17.
//  Copyright © 2017 MoveForward. All rights reserved.
//

import Foundation

func scanUIntParameter(paramDescription: String, maxValue: UInt) -> UInt {
    while(true) {
        print("Enter " + paramDescription + ":")
        if let paramString = readLine(), let param = UInt(paramString), param <= maxValue {
            return param
        }
        print("invalid " + paramDescription)
    }
}

print("---Enter start date---")
let startDay: UInt = scanUIntParameter(paramDescription: "start day", maxValue: 31)
let startMonth: UInt = scanUIntParameter(paramDescription: "start month, zero based", maxValue: 11)
let startYear: UInt = scanUIntParameter(paramDescription: "start year", maxValue: 9999)
print("Start date: day: \(startDay), month: \(startMonth), year: \(startYear)")

print("---Enter end date---")
let endDay: UInt = scanUIntParameter(paramDescription: "end day", maxValue: 31)
let endMonth: UInt = scanUIntParameter(paramDescription: "end month, zero based", maxValue: 11)
let endYear: UInt = scanUIntParameter(paramDescription: "end year", maxValue: 2999)
print("End date: day: \(endDay), month: \(endMonth), year: \(endYear)")

let start = Date(year: startYear, month: Month(rawValue: startMonth)!, day:startDay)
let end = Date(year: endYear, month: Month(rawValue: endMonth)!, day: endDay)
let result = DateUtils.daysBetween(start: start, end: end)

switch result {
case .success(let days):
    print("days: \(days)")
case .failure(let error):
    print("error: \(error)")
}

