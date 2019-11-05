//
//  Submission.swift
//  skolera
//
//  Created by Rana Hossam on 10/17/19.
//  Copyright © 2019 Skolera. All rights reserved.

import Foundation

class Submission {

    let id: Int!
    let score: Int!
    let feedback: String!
    let studentName: String!
    let studentId: Int!
    let createdAt: String!
    let studentAvatarUrl: String!
    let isSubmitted: Bool!
    let studentStatus: String!
    let gradeView: Int!
    let isHidden: Bool!
    let graded: Bool!

    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        score = dict["score"] as? Int
        feedback = dict["feedback"] as? String
        studentName = dict["student_name"] as? String
        studentId = dict["student_id"] as? Int
        createdAt = dict["created_at"] as? String
        studentAvatarUrl = dict["student_avatar_url"] as? String
        isSubmitted = dict["is_submitted"] as? Bool
        studentStatus = dict["student_status"] as? String
        gradeView = dict["grade_view"] as? Int
        isHidden = dict["is_hidden"] as? Bool
        graded = dict["graded"] as? Bool
    }

}
