//
//  GradeCategory.swift
//  skolera
//
//  Created by Salma Medhat on 2/11/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GradeCategory {

        let id: Int
        let weight: Double
        let name: String
        let total: Double
        let grade: String
        let quizzesTotal: Double
        let quizzesGrade: Double
        let quizzes: [StudentGrade]
        let assignmentsTotal: Double
        let assignmentsGrade: Double
        let assignments: [StudentGrade]
        let gradeItemsTotal: Double
        let gradeItemsGrade: Double
        let gradeItems: [StudentGrade]
        let gradeView: String
        let percentage: Double
        var isParent = true
        let subCategories: [GradeCategory]

        init(_ dict: [String: Any]) {
            id = dict["id"] as! Int
            weight = dict["weight"] as! Double
            name = dict["name"] as! String
            total = dict["total"] as! Double
            grade = dict["grade"] as! String
            
            quizzesTotal = dict["quizzes_total"] as! Double
            quizzesGrade = dict["quizzes_grade"] as! Double
            if let quizzesDictArray = dict["quizzes"] as? [[String: Any]] {
                quizzes = quizzesDictArray.map { StudentGrade($0) }
            } else {
                quizzes = []
            }
            
            assignmentsTotal = dict["assignments_total"] as! Double
            assignmentsGrade = dict["assignments_grade"] as! Double
            if let assignmentsDictArray = dict["assignments"] as? [[String: Any]] {
                assignments = assignmentsDictArray.map { StudentGrade($0) }
            } else {
                assignments = []
            }
            
            gradeItemsTotal = dict["grade_items_total"] as! Double
            gradeItemsGrade = dict["grade_items_grade"] as! Double
            if let gradeItemsDictArray = dict["grade_items"] as? [[String: Any]] {
                gradeItems = gradeItemsDictArray.map { StudentGrade($0) }
            } else {
                gradeItems = []
            }
            
            
            gradeView = dict["grade_view"] as! String
            percentage = dict["percentage"] as! Double

            if let subCategoriesDictArray = dict["sub_categories"] as? [[String: Any]] {
                subCategories = subCategoriesDictArray.map { let gradeCatagory = GradeCategory($0)
                    gradeCatagory.isParent = false
                    return gradeCatagory
                }
                
            } else {
                subCategories = []
            }
        }

        func toDictionary() -> [String: Any] {
            var jsonDict = [String: Any]()
            jsonDict["id"] = id
            jsonDict["weight"] = weight
            jsonDict["name"] = name
            jsonDict["total"] = total
            jsonDict["grade"] = grade
            jsonDict["quizzes_total"] = quizzesTotal
            jsonDict["quizzes_grade"] = quizzesGrade
            jsonDict["quizzes"] = quizzes
            jsonDict["assignments_total"] = assignmentsTotal
            jsonDict["assignments_grade"] = assignmentsGrade
            jsonDict["assignments"] = assignments
            jsonDict["grade_items_total"] = gradeItemsTotal
            jsonDict["grade_items_grade"] = gradeItemsGrade
            jsonDict["grade_items"] = gradeItems
            jsonDict["grade_view"] = gradeView
            jsonDict["percentage"] = percentage
            jsonDict["sub_categories"] = subCategories.map { $0.toDictionary() }
            return jsonDict
        }

    }
