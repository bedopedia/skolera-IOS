//
//  GradingPeriodGrade.swift
//  skolera
//
//  Created by Salma Medhat on 2/11/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GradeInGradingPeriod {

    let id: Int
    let name: String
    let startDate: String
    let endDate: String
    let createdAt: String
    let updatedAt: String
    let weight: Int
    let lock: Bool
    let publish: Bool
    let coursesGradingPeriodId: Int
    let categories: [GradeCategory]
    let total: Double
    let grade: String
    let percentage: Double
    let gradeView: String
    let letterScale: String
    let gpaScale: String

    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        name = dict["name"] as! String
        startDate = dict["start_date"] as! String
        endDate = dict["end_date"] as! String
        createdAt = dict["created_at"] as! String
        updatedAt = dict["updated_at"] as! String
        weight = dict["weight"] as! Int
        lock = dict["lock"] as! Bool
        publish = dict["publish"] as! Bool
        coursesGradingPeriodId = dict["courses_grading_period_id"] as! Int
        
        if let categoriesDictArray = dict["categories"] as? [[String: Any]] {
            categories = categoriesDictArray.map { GradeCategory($0) }
        } else {
            categories = []
        }
        
        total = dict["total"] as! Double
        grade = dict["grade"] as! String
        percentage = dict["percentage"] as! Double
        gradeView = dict["grade_view"] as! String
        letterScale = dict["letter_scale"] as! String
        gpaScale = dict["gpa_scale"] as! String
    }

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["start_date"] = startDate
        jsonDict["end_date"] = endDate
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["weight"] = weight
        jsonDict["lock"] = lock
        jsonDict["publish"] = publish   
        jsonDict["courses_grading_period_id"] = coursesGradingPeriodId
        jsonDict["categories"] = categories.map { $0.toDictionary() }
        jsonDict["total"] = total
        jsonDict["grade"] = grade
        jsonDict["percentage"] = percentage
        jsonDict["grade_view"] = gradeView
        jsonDict["letter_scale"] = letterScale
        jsonDict["gpa_scale"] = gpaScale
        return jsonDict
    }

}
