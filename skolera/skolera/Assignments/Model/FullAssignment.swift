//
//  FullAssignment.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class FullAssignment {
    let id: Int!
    let name: String?
    let description: String!
    let state: String!
    let endAt: String!
    let startAt: String!
    let assignmentType: String!
    let blooms: [String]!
    let points: Int!
    let lateSubmissionsDate: String!
    let lateSubmissionPoints: Any!
    let content: String!
    let category: Any!
    let lessonName: String!
    let chapterName: String!
    let fileName: Any!
    let teacherId: Int!
    let onlineText: Bool!
    let fileUpload: Bool!
    let hardCopy: Bool!
    let unitName: String!
    let lateSubmission: Bool!
    let submissionsStudentIds: [Any]!
    let adminId: Any!
    let fileUrl: Any!
    let contentType: Any!
    let assignmentsCourseGroups: [Any]!
    let assignmentsObjectives: [Any]!
    let gradingPeriodLock: Bool!
    let courseGroups: [Any]!
    let objectives: [Any]!
    let uploadedFiles: [UploadedFile]!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        description = dict["description"] as? String
        state = dict["state"] as? String
        endAt = dict["end_at"] as? String
        startAt = dict["start_at"] as? String
        assignmentType = dict["assignment_type"] as? String
        blooms = dict["blooms"] as? [String]
        points = dict["points"] as? Int
        lateSubmissionsDate = dict["late_submissions_date"] as? String
        lateSubmissionPoints = dict["late_submission_points"] as? Any
        content = dict["content"] as? String
        category = dict["category"] as? Any
        lessonName = dict["lesson_name"] as? String
        chapterName = dict["chapter_name"] as? String
        fileName = dict["file_name"] as? Any
        teacherId = dict["teacher_id"] as? Int
        onlineText = dict["online_text"] as? Bool
        fileUpload = dict["file_upload"] as? Bool
        hardCopy = dict["hard_copy"] as? Bool
        unitName = dict["unit_name"] as? String
        lateSubmission = dict["late_submission"] as? Bool
        submissionsStudentIds = dict["submissions_student_ids"] as? [Any]
        adminId = dict["admin_id"] as? Any
        fileUrl = dict["file_url"] as? Any
        contentType = dict["content_type"] as? Any
        assignmentsCourseGroups = []
        assignmentsObjectives = dict["assignments_objectives"] as? [Any]
        gradingPeriodLock = dict["grading_period_lock"] as? Bool
        courseGroups = []
        objectives = dict["objectives"] as? [Any]
        
        if let uploadedFilesDictArray = dict["uploaded_files"] as? [[String: Any]] {
            uploadedFiles = uploadedFilesDictArray.map { UploadedFile($0) }
        } else {
            uploadedFiles = []
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["description"] = description
        jsonDict["state"] = state
        jsonDict["end_at"] = endAt
        jsonDict["start_at"] = startAt
        jsonDict["assignment_type"] = assignmentType
        jsonDict["blooms"] = blooms
        jsonDict["points"] = points
        jsonDict["late_submissions_date"] = lateSubmissionsDate
        jsonDict["late_submission_points"] = lateSubmissionPoints
        jsonDict["content"] = content
        jsonDict["category"] = []
        jsonDict["lesson_name"] = lessonName
        jsonDict["chapter_name"] = chapterName
        jsonDict["file_name"] = fileName
        jsonDict["teacher_id"] = teacherId
        jsonDict["online_text"] = onlineText
        jsonDict["file_upload"] = fileUpload
        jsonDict["hard_copy"] = hardCopy
        jsonDict["unit_name"] = unitName
        jsonDict["late_submission"] = lateSubmission
        jsonDict["submissions_student_ids"] = submissionsStudentIds
        jsonDict["admin_id"] = adminId
        jsonDict["file_url"] = fileUrl
        jsonDict["content_type"] = contentType
        jsonDict["assignments_course_groups"] = []
        jsonDict["assignments_objectives"] = assignmentsObjectives
        jsonDict["grading_period_lock"] = gradingPeriodLock
        jsonDict["course_groups"] = []
        jsonDict["objectives"] = objectives
        jsonDict["uploaded_files"] = uploadedFiles?.map { $0.toDictionary() }
        return jsonDict
    }
    
}
