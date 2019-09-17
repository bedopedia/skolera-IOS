//
//  TimeTableSlots.swift
//  skolera
//
//  Created by Rana Hossam on 9/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//
//
import Foundation

class TimetableSlots {
    
    let id: Int!
    let day: String!
    let slotNo: Int!
    let from: String!
    let to: String!
    let sectionName: String!
    let courseName: String!
    let courseGroupName: String!
    let schoolUnit: String!
    let dayNumber: Int!
    let schoolUnitId: Any!
    let courseGroupId: Int!
    let courseId: Int!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        day = dict["day"] as? String
        slotNo = dict["slot_no"] as? Int
        from = dict["from"] as? String
        to = dict["to"] as? String
        sectionName = dict["section_name"] as? String
        courseName = dict["course_name"] as? String
        courseGroupName = dict["course_group_name"] as? String
        schoolUnit = dict["school_unit"] as? String
        dayNumber = dict["day_number"] as? Int
        schoolUnitId = dict["school_unit_id"]
        courseGroupId = dict["course_group_id"] as? Int
        courseId = dict["course_id"] as? Int
    }
}
