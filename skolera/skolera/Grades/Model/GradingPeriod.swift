//
//  GradingPeriod.swift
//  skolera
//
//  Created by Salma Medhat on 1/28/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GradingPeriod {
    
    let id: Int?
    let name: String?
    let startDate: String?
    let endDate: String?
    let gradeItems: [StudentGrade]?
    let quizzes: [StudentGrade]?
    let assignments: [StudentGrade]?
    let subGradingPeriods: [GradingPeriod]?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        startDate = dict["start_date"] as? String
        endDate = dict["end_date"] as? String
        
        if let gradeItemsDictArray = dict["grade_items"] as? [[String: Any]] {
            gradeItems = gradeItemsDictArray.map { StudentGrade($0) }
        } else {
            gradeItems = []
        }
        
        if let quizzesDictArray = dict["quizzes"] as? [[String: Any]] {
            quizzes = quizzesDictArray.map { StudentGrade($0) }
        } else {
            quizzes = []
        }
        
        if let assignmentsDictArray = dict["assignments"] as? [[String: Any]] {
            assignments = assignmentsDictArray.map { StudentGrade($0) }
        } else {
            assignments = []
        }
        
        if let subGradingPeriodsDictArray = dict["sub_grading_periods"] as? [[String: Any]] {
            subGradingPeriods = subGradingPeriodsDictArray.map { GradingPeriod($0) }
        } else {
            subGradingPeriods = []
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["start_date"] = startDate
        jsonDict["end_date"] = endDate
        jsonDict["grade_items"] = gradeItems?.map { $0.toDictionary() }
        jsonDict["quizzes"] = quizzes?.map { $0.toDictionary() }
        jsonDict["assignments"] = assignments?.map { $0.toDictionary() }
        jsonDict["sub_grading_periods"] = subGradingPeriods
        return jsonDict
    }
    
}
