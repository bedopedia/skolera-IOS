//
//  TeacherCourse.swift
//  skolera
//
//  Created by Yehia Beram on 7/30/19.
//  Copyright © 2019 Skolera. All rights reserved.
//


import Foundation

class TeacherCourse {
    
    let id: Int!
    let name: String!
    let code: String!
    let courseGroups: [CourseGroup]!
    let courseGroupIds: [Int]!
    let sectionName: String!
    let levelName: String!
    let stageName: String!
    let totalGrade: Int!
    let passLimit: Int!
    let showFinalGrade: Bool!
    let iconName: Any!
    let hodId: Int!
    let sectionId: Int!
    let weekLessons: [Any]!
    let courseGradingPeriods: [CourseGradingPeriods]!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        code = dict["code"] as? String
        
        if let courseGroupsDictArray = dict["course_groups"] as? [[String: Any]] {
            courseGroups = courseGroupsDictArray.map { CourseGroup(fromDictionary: $0) }
        } else {
            courseGroups = []
        }
        courseGroupIds = dict["course_group_ids"] as? [Int]
        
        sectionName = dict["section_name"] as? String
        levelName = dict["level_name"] as? String
        stageName = dict["stage_name"] as? String
        totalGrade = dict["total_grade"] as? Int
        passLimit = dict["pass_limit"] as? Int
        showFinalGrade = dict["show_final_grade"] as? Bool
        iconName = dict["icon_name"] as? Any
        hodId = dict["hod_id"] as? Int
        sectionId = dict["section_id"] as? Int
        weekLessons = dict["week_lessons"] as? [Any]
        
        if let courseGradingPeriodsDictArray = dict["course_grading_periods"] as? [[String: Any]] {
            courseGradingPeriods = courseGradingPeriodsDictArray.map { CourseGradingPeriods(fromDictionary: $0) }
        } else {
            courseGradingPeriods = []
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["code"] = code
        jsonDict["course_groups"] = courseGroups?.map { $0.toDictionary() }
        jsonDict["course_group_ids"] = courseGroupIds
        jsonDict["section_name"] = sectionName
        jsonDict["level_name"] = levelName
        jsonDict["stage_name"] = stageName
        jsonDict["total_grade"] = totalGrade
        jsonDict["pass_limit"] = passLimit
        jsonDict["show_final_grade"] = showFinalGrade
        jsonDict["icon_name"] = iconName
        jsonDict["hod_id"] = hodId
        jsonDict["section_id"] = sectionId
        jsonDict["week_lessons"] = weekLessons
        jsonDict["course_grading_periods"] = courseGradingPeriods?.map { $0.toDictionary() }
        return jsonDict
    }
    
}
