//
//  StudentSubmissions.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
class StudentSubmissions {
    
    let id: Int!
    let grade: Int!
    let graded: Bool!
    let assignmentId: Int!
    let studentId: Int!
    let createdAt: String!
    let updatedAt: String!
    let answers: String!
    let file: FileModel?
    let feedback: String!
    let courseGroupId: Int!
    let downloadsNumber: Int!
    let deletedAt: String!
    let studentStatus: String!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        grade = dict["grade"] as? Int
        graded = dict["graded"] as? Bool
        assignmentId = dict["assignment_id"] as? Int
        studentId = dict["student_id"] as? Int
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        answers = dict["answers"] as? String
        
        if let fileDict = dict["file"] as? [String: Any] {
            file = FileModel(fileDict)
        } else {
            file = nil
        }
        feedback = dict["feedback"] as? String
        courseGroupId = dict["course_group_id"] as? Int
        downloadsNumber = dict["downloads_number"] as? Int
        deletedAt = dict["deleted_at"] as? String
        studentStatus = dict["student_status"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["grade"] = grade
        jsonDict["graded"] = graded
        jsonDict["assignment_id"] = assignmentId
        jsonDict["student_id"] = studentId
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["answers"] = answers
        jsonDict["file"] = file?.toDictionary()
        jsonDict["feedback"] = feedback
        jsonDict["course_group_id"] = courseGroupId
        jsonDict["downloads_number"] = downloadsNumber
        jsonDict["deleted_at"] = deletedAt
        jsonDict["student_status"] = studentStatus
        return jsonDict
    }
    
}
