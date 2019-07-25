//
//  StudentSubmission.swift
//  skolera
//
//  Created by Yehia Beram on 7/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class StudentSubmission {
    
    let id: Int!
    let score: Double!
    let studentId: Int!
    let createdAt: String!
    let updatedAt: String!
    let quizId: Int!
    let courseGroupId: Int!
    let feedback: String!
    let isSubmitted: Bool!
    let deletedAt: String!
    let studentStatus: String!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        score = dict["score"] as? Double
        studentId = dict["student_id"] as? Int
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        quizId = dict["quiz_id"] as? Int
        courseGroupId = dict["course_group_id"] as? Int
        feedback = dict["feedback"] as? String
        isSubmitted = dict["is_submitted"] as? Bool
        deletedAt = dict["deleted_at"] as? String
        studentStatus = dict["student_status"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["score"] = score
        jsonDict["student_id"] = studentId
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["quiz_id"] = quizId
        jsonDict["course_group_id"] = courseGroupId
        jsonDict["feedback"] = feedback
        jsonDict["is_submitted"] = isSubmitted
        jsonDict["deleted_at"] = deletedAt
        jsonDict["student_status"] = studentStatus
        return jsonDict
    }

    
}
