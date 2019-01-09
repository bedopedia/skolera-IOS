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
    var gradeView: Double
    var feedback: String
    var createdAt: String
    
    
    init(id: Int, name: String, total: Double, grade: Double, gradeView: Double, feedback: String, createdAt: String) {
        self.id = id
        self.name = name
        self.total = total
        self.grade = grade
        self.gradeView = gradeView
        self.feedback = feedback
        self.createdAt = createdAt
    }
}
