//
//  FullDayAttendances.swift
//  skolera
//
//  Created by Rana Hossam on 9/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class FullDayAttendances {
    
    let attendances: [Attendances]!
    let students: [Students]!
    
    init(_ dict: [String: Any]) {
        if let attendancesDictArray = dict["attendances"] as? [[String: Any]] {
            attendances = attendancesDictArray.map { Attendances($0) }
        } else {
            attendances = nil
        }
        if let studentsDictArray = dict["students"] as? [[String: Any]] {
            students = studentsDictArray.map { Students($0) }
        } else {
            students = nil
        }
    }
    
}
