//
//  QuizCourse.swift
//  skolera
//
//  Created by Yehia Beram on 7/24/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class QuizCourse {
    let id: Int!
    let name: String!
    let courseName: String!
    let courseId: Int!
    let quizzesCount: Int!
    let nextQuizDate: String!
    let quizName: String!
    let quizState: String!
    let nextQuizStartDate: String!
    let runningQuizzesCount: Int!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        courseName = dict["course_name"] as? String
        courseId = dict["course_id"] as? Int
        quizzesCount = dict["quizzes_count"] as? Int
        nextQuizDate = dict["next_quiz_date"] as? String
        quizName = dict["quiz_name"] as? String
        quizState = dict["quiz_state"] as? String
        nextQuizStartDate = dict ["next_quiz_start_date"] as? String
        runningQuizzesCount = dict["running_assignments_count"] as? Int
    }
    
}
