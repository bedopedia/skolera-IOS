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
