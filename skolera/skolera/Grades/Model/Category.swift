//
//  Category.swift
//  skolera
//
//  Created by Rana Hossam on 1/6/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GradeCategory {

    let id: Int?
    let weight: Int?
    let name: String?
    let parentId: Any?
    let total: Int?
    let grade: String?
    let quizzesTotal: Int?
    let quizzesGrade: Int?
    let quizzes: [Quiz]?
    let assignmentsTotal: Int?
    let assignmentsGrade: Int?
    let assignments: [Assignment]?
    let gradeItemsTotal: Int?
    let gradeItemsGrade: Int?
    let gradeItems: [GradeItem]?
    let percentage: Double?
    let gradeView: String?
    let subCategories: [Any]?

    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        weight = dict["weight"] as? Int
        name = dict["name"] as? String
        parentId = dict["parent_id"] as? Any
        total = dict["total"] as? Int
        grade = dict["grade"] as? String
        quizzesTotal = dict["quizzes_total"] as? Int
        quizzesGrade = dict["quizzes_grade"] as? Int

        if let quizzesDictArray = dict["quizzes"] as? [[String: Any]] {
            quizzes = quizzesDictArray.map { Quiz($0) }
        } else {
            quizzes = nil
        }
        assignmentsTotal = dict["assignments_total"] as? Int
        assignmentsGrade = dict["assignments_grade"] as? Int

        if let assignmentsDictArray = dict["assignments"] as? [[String: Any]] {
            assignments = assignmentsDictArray.map { Assignment($0) }
        } else {
            assignments = nil
        }
        gradeItemsTotal = dict["grade_items_total"] as? Int
        gradeItemsGrade = dict["grade_items_grade"] as? Int

        if let gradeItemsDictArray = dict["grade_items"] as? [[String: Any]] {
            gradeItems = gradeItemsDictArray.map { GradeItem($0) }
        } else {
            gradeItems = nil
        }
        percentage = dict["percentage"] as? Double
        gradeView = dict["grade_view"] as? String
        subCategories = dict["sub_categories"] as? [Any]
    }

  

}
