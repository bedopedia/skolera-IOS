//
//  StudentGrade.swift
//  skolera
//
//  Created by Salma Medhat on 1/28/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class StudentGrade {
    
    let id: Int
    let name: String
    let gradingPeriodId: Int
    let hideGrade: Bool
    let type: String
    let total: Double
    let grade: Double
    let status: Int
    let gradeView: String
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        name = dict["name"] as! String
        gradingPeriodId = dict["grading_period_id"] as! Int
        hideGrade = dict["hide_grade"] as! Bool
        type = dict["type"] as! String
        total = dict["total"] as! Double
        grade = dict["grade"] as! Double
        status = dict["status"] as? Int ?? 0
        gradeView = dict["grade_view"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["grading_period_id"] = gradingPeriodId
        jsonDict["hide_grade"] = hideGrade
        jsonDict["type"] = type
        jsonDict["total"] = total
        jsonDict["grade"] = grade
        jsonDict["status"] = status
        jsonDict["grade_view"] = gradeView
        return jsonDict
    }
    
}
