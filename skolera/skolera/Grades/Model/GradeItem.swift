//
//  GradeItem.swift
//  skolera
//
//  Created by Yehia Beram on 6/19/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation

class GradeItem {
    var id: Int
    var name: String
    var maxGrade: Int
    var total: Double
    var grade: Double
    var gradeView: String
    var feedback: String
    var createdAt: String
    var periodId: Int
    
    init(id: Int, name: String, maxGrade: Int, total: Double, grade: Double, gradeView: String, feedback: String, createdAt: String, periodId: Int) {
        self.id = id
        self.name = name
        self.maxGrade = maxGrade
        self.total = total
        self.grade = grade
        self.gradeView = gradeView
        self.feedback = feedback
        self.createdAt = createdAt
        self.periodId = periodId
    }
}
