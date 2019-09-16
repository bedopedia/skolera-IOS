//
//  Attendances.swift
//  skolera
//
//  Created by Rana Hossam on 9/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class Attendances {
    
    let id: Int!
    let date: Int!
    let comment: Any!
    let status: String!
    let timetableSlotId: Any!
    let studentId: Int!
    let student: AttendanceStudent!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        date = dict["date"] as? Int
        comment = dict["comment"]
        status = dict["status"] as? String
        timetableSlotId = dict["timetable_slot_id"] 
        studentId = dict["student_id"] as? Int
        
        if let studentDict = dict["student"] as? [String: Any] {
            student = AttendanceStudent(studentDict)
        } else {
            student = nil
        }
    }
    
}
