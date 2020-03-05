//
//  AssignmentCourse.swift
//  skolera
//
//  Created by Yehia Beram on 6/12/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
class AssignmentCourse {
    
    let id: Int!
    let name: String!
    let courseName: String!
    let courseId: Int!
    let assignmentsCount: Int!
    let nextAssignmentDate: String!
    let assignmentName: String!
    let assignmentState: String!
    let nextAssignmentStartDate: String!
    let runningAssignmentsCount: Int!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        courseName = dict["course_name"] as? String
        courseId = dict["course_id"] as? Int
        assignmentsCount = dict["assignments_count"] as? Int
        nextAssignmentDate = dict["next_assignment_date"] as? String
        assignmentName = dict["assignment_name"] as? String
        assignmentState = dict["assignment_state"] as? String
        nextAssignmentStartDate = dict ["next_assignment_start_date"] as? String
        runningAssignmentsCount = dict["running_assignments_count"] as? Int
    }
    
}
