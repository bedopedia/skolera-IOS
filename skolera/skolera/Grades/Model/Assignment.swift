//
//  Assignment.swift
//  skolera
//
//  Created by Yehia Beram on 6/19/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation

class Assignment{
    var id: Int
    var name: String
    var total: Double
    var grade: Double
    var gradeView: String
    var feedback: String
    var createdAt: String
    var hideGrade: Bool
    
    
    
    init(id: Int, name: String, total: Double, grade: Double, gradeView: String, feedback: String, createdAt: String, hideGrade: Bool) {
        self.id = id
        self.name = name
        self.total = total
        self.grade = grade
        self.gradeView = gradeView
        self.feedback = feedback
        self.createdAt = createdAt
        
        self.hideGrade = hideGrade
    }
}

//class Assignment{
//
//    var id: Int!
//    var name: String!
//    var total: Double!
//    var grade: Double!
//    var gradeView: String!
//    var feedback: String!
//    var createdAt: String!
//    var hideGrade: Bool!
//    let categoryId: Int!
//    let type: String!
//    let status: String!
//    let feedbackId: String!
//
//
//    init(_ dict: [String: Any]) {
//        id = dict["id"] as? Int
//        name = dict["name"] as? String
//        categoryId = dict["category_id"] as? Int
//        type = dict["type"] as? String
//        total = dict["total"] as? Double
//        grade = dict["grade"] as? Double
//        status = dict["status"] as? String
//        hideGrade = dict["hide_grade"] as? Bool ?? false
//        feedback = dict["feedback_content"] as? String ?? ""
//        feedbackId = dict["feedback_id"] as? String
//        gradeView = dict["grade_view"] as? String ?? "\(dict["grade_view"] as? Double ?? 0)"
//        createdAt = dict["end_date"] as? String
//    }
//}
//
