//
//  GradeItem.swift
//  skolera
//
//  Created by Yehia Beram on 6/19/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation

class GradeItem {
    var id: Int!
    var name: String!
    var total: Double!
    var grade: Double!
    var gradeView: String!
    var feedback: String!
    var createdAt: String!
    var periodId: Int!
    var hideGrade: Bool!
    let categoryId: Int!
    let type: String!
    let status: Int!
    let feedbackId: String!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        categoryId = dict["category_id"] as? Int
        hideGrade = dict["hide_grade"] as? Bool
        type = dict["type"] as? String
        status = dict["status"] as? Int
        feedback = dict["feedback_content"] as? String
        feedbackId = dict["feedback_id"] as? String
        gradeView = dict["grade_view"] as? String ?? "\(dict["grade_view"] as? Double ?? 0)"
        total = dict["total"] as? Double
        grade = dict["grade"] as? Double
        createdAt = dict["end_date"] as? String
        periodId = dict["period_id"] as? Int
    }

    
}
