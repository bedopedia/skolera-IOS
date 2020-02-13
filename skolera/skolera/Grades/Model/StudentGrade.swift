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
    let categoryId: Int
    let type: String
    let total: Int
    let grade: Int?
    let hideGrade: Int
    let gradeView: String
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        name = dict["name"] as! String
        categoryId = dict["category_id"] as! Int
        type = dict["type"] as! String
        total = dict["total"] as! Int
        grade = dict["grade"] as? Int
        hideGrade = dict["hide_grade"] as! Int
        gradeView = dict["grade_view"] as! String
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["category_id"] = categoryId
        jsonDict["type"] = type
        jsonDict["total"] = total
        jsonDict["grade"] = grade
        jsonDict["hide_grade"] = hideGrade
        jsonDict["grade_view"] = gradeView
        return jsonDict
    }
    
}
