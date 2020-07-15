//
//  Date+Time.swift
//  skolera
//
//  Created by Ismail Ahmed on 4/22/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
extension Date {
    var time: Time {
        return Time(self)
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
    
        func convertTimeZone(from initTimeZone: TimeZone, to targetTimeZone: TimeZone) -> Date {
            let delta = TimeInterval(initTimeZone.secondsFromGMT() - targetTimeZone.secondsFromGMT())
            debugPrint("DATEEEE:", addingTimeInterval(delta))
            return addingTimeInterval(delta)
        }
    
    
    
}

