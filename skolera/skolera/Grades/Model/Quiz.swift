//
//  Quiz.swift
//  skolera
//
//  Created by Yehia Beram on 6/19/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation

class Quiz{
    var id: Int
    var name: String
    var totalScore: Double
    var total: Double
    var grade: Double
    var gradeView: String
    var feedback: String
    var createdAt: String
    var hideGrade: Bool
    
    init(id: Int, name: String, totalScore: Double, total: Double, grade: Double, gradeView: String, feedback: String, createdAt: String, hideGrade: Bool) {
        self.id = id
        self.name = name
        self.totalScore = totalScore
        self.total = total
        self.grade = grade
        self.gradeView = gradeView
        self.feedback = feedback
        self.createdAt = createdAt
        self.hideGrade = hideGrade
    }
}
