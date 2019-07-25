//
//  Quiz.swift
//  skolera
//
//  Created by Yehia Beram on 7/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class FullQuiz {
    
    let id: Int!
    let name: String!
    let startDate: String!
    let endDate: String!
    let description: String!
    let duration: Int!
    let isQuestionsRandomized: Bool!
    let numOfQuestionsPerPage: Int!
    let state: String!
    let totalScore: Double!
    let lessonId: Int!
    let gradingPeriodLock: Bool!
    let studentSubmissions: StudentSubmission!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        startDate = dict["start_date"] as? String
        endDate = dict["end_date"] as? String
        description = dict["description"] as? String
        duration = dict["duration"] as? Int
        isQuestionsRandomized = dict["is_questions_randomized"] as? Bool
        numOfQuestionsPerPage = dict["num_of_questions_per_page"] as? Int
        state = dict["state"] as? String
        totalScore = dict["total_score"] as? Double
        lessonId = dict["lesson_id"] as? Int
        gradingPeriodLock = dict["grading_period_lock"] as? Bool
        
        if let studentSubmissionsDict = dict["student_submissions"] as? [String: Any] {
            studentSubmissions = StudentSubmission(studentSubmissionsDict)
        } else {
            studentSubmissions = StudentSubmission([:])
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["start_date"] = startDate
        jsonDict["end_date"] = endDate
        jsonDict["description"] = description
        jsonDict["duration"] = duration
        jsonDict["is_questions_randomized"] = isQuestionsRandomized
        jsonDict["num_of_questions_per_page"] = numOfQuestionsPerPage
        jsonDict["state"] = state
        jsonDict["total_score"] = totalScore
        jsonDict["lesson_id"] = lessonId
        jsonDict["grading_period_lock"] = gradingPeriodLock
        jsonDict["student_submissions"] = studentSubmissions?.toDictionary()
        return jsonDict
    }

}
