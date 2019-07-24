//
//  FullAssignment.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class FullAssignment {
    
    let id: Int!
    let name: String!
    let description: String!
    let state: String!
    let endAt: String!
    let startAt: String!
    let lessonId: Int!
    let fileName: String!
    let unitId: Int!
    let studentSubmitted: Bool!
    let gradingPeriodLock: Bool!
    let studentSubmissions: StudentSubmissions?
    
    init(_ dict: [String: Any]) {
        debugPrint(dict)
        id = dict["id"] as? Int
        name = dict["name"] as? String
        description = dict["description"] as? String
        state = dict["state"] as? String
        endAt = dict["end_at"] as? String
        startAt = dict["start_at"] as? String
        lessonId = dict["lesson_id"] as? Int
        fileName = dict["file_name"] as? String
        unitId = dict["unit_id"] as? Int
        studentSubmitted = dict["student_submitted"] as? Bool
        gradingPeriodLock = dict["grading_period_lock"] as? Bool
        
        if let studentSubmissionsDict = dict["student_submissions"] as? [String: Any] {
            studentSubmissions = StudentSubmissions(studentSubmissionsDict)
        } else {
            studentSubmissions = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["description"] = description
        jsonDict["state"] = state
        jsonDict["end_at"] = endAt
        jsonDict["start_at"] = startAt
        jsonDict["lesson_id"] = lessonId
        jsonDict["file_name"] = fileName
        jsonDict["unit_id"] = unitId
        jsonDict["student_submitted"] = studentSubmitted
        jsonDict["grading_period_lock"] = gradingPeriodLock
        jsonDict["student_submissions"] = studentSubmissions?.toDictionary()
        return jsonDict
    }
    
}
