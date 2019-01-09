//
//  Student.swift
//  skolera
//
//  Created by Yehia Beram on 6/19/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation

class Student{
    var id: Int
    var name: String
    var userId: Int
    var assignments : [Assignment]
    var quizzes: [Quiz]
    var gradeItems: [GradeItem]
    
    init(id: Int, name: String, userId: Int, assignments : [Assignment], quizzes: [Quiz], gradeItems: [GradeItem]) {
        self.id = id
        self.name = name
        self.userId = userId
        self.assignments = assignments
        self.quizzes = quizzes
        self.gradeItems = gradeItems
    }
}
