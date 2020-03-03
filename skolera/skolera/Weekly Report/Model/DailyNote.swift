//
//    DailyNote.swift
//
//    Create by Salma MEdhat on 2/13/2019
//    Copyright © 2019 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class DailyNote {
    
    let id: Int
    let title: String
    let classWork: String
    let homework: String
    let activities: String
    let date: String
    let weeklyPlanId: Int
    let createdAt: String
    let updatedAt: String
    let courseId: Int
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        title = dict["title"] as! String
        classWork = dict["class_work"] as! String
        homework = dict["homework"] as! String
        activities = dict["activities"] as! String
        date = dict["date"] as! String
        weeklyPlanId = dict["weekly_plan_id"] as! Int
        createdAt = dict["created_at"] as! String
        updatedAt = dict["updated_at"] as! String
        courseId = dict["course_id"] as! Int
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["title"] = title
        jsonDict["class_work"] = classWork
        jsonDict["homework"] = homework
        jsonDict["activities"] = activities
        jsonDict["date"] = date
        jsonDict["weekly_plan_id"] = weeklyPlanId
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["course_id"] = courseId
        return jsonDict
    }
    
}
