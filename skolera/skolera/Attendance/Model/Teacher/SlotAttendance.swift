//
//  SlotAttendance.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 17, 2019
//
import Foundation

class SlotAttendance {
    
    let attendances: [Attendances]?
    let students: [AttendanceStudent]?
    let timetableSlots: [TimetableSlots]?
    
    init(_ dict: [String: Any]) {
        
        if let attendancesDictArray = dict["attendances"] as? [[String: Any]] {
            attendances = attendancesDictArray.map { Attendances($0) }
        } else {
            attendances = nil
        }
        if let studentsDictArray = dict["students"] as? [[String: Any]] {
            students = studentsDictArray.map { AttendanceStudent($0) }
        } else {
            students = nil
        }
        
        if let timetableSlotsDictArray = dict["timetable_slots"] as? [[String: Any]] {
            timetableSlots = timetableSlotsDictArray.map { TimetableSlots($0) }
        } else {
            timetableSlots = nil
        }
    }
}
