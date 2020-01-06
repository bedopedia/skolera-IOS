//
//  GradeBook.swift
//  skolera
//
//  Created by Rana Hossam on 1/6/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GradeBook {

    let id: Int?
    let name: String?
    let startDate: String?
    let endDate: String?
    let createdAt: String?
    let updatedAt: String?
    let levelId: Any?
    let academicTermId: Int?
    let deletedAt: Any?
    let weight: Int?
    let parentId: Any?
    let lock: Bool?
    let publish: Bool?
    let categoryIsNumeric: Bool?
    let coursesGradingPeriodId: Int?
    let categories: [GradeCategory]?
    let total: Int?
    let grade: String?
    let percentage: Double?
    let gradeView: String?
    let letterScale: String?
    let gpaScale: String?

    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        startDate = dict["start_date"] as? String
        endDate = dict["end_date"] as? String
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        levelId = dict["level_id"] as? Any
        academicTermId = dict["academic_term_id"] as? Int
        deletedAt = dict["deleted_at"] as? Any
        weight = dict["weight"] as? Int
        parentId = dict["parent_id"] as? Any
        lock = dict["lock"] as? Bool
        publish = dict["publish"] as? Bool
        categoryIsNumeric = dict["category_is_numeric"] as? Bool
        coursesGradingPeriodId = dict["courses_grading_period_id"] as? Int

        if let categoriesDictArray = dict["categories"] as? [[String: Any]] {
            categories = categoriesDictArray.map { GradeCategory($0) }
        } else {
            categories = nil
        }
        total = dict["total"] as? Int
        grade = dict["grade"] as? String
        percentage = dict["percentage"] as? Double
        gradeView = dict["grade_view"] as? String
        letterScale = dict["letter_scale"] as? String
        gpaScale = dict["gpa_scale"] as? String
    }


}
