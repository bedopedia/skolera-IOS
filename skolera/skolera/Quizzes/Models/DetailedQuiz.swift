
//  Created by Rana Hossam on 9/26/19.
//  Copyright © 2019 Skolera. All rights reserved.
//  Generated using https://jsonmaster.github.io

import Foundation

class DetailedQuiz {
    
    let id: Int!
    let name: String!
    let startDate: String!
    let endDate: String!
    let description: String!
    let courseGroups: [CourseGroups]!
    let category: Category!
    let lesson: Lesson!
    let unit: Unit!
    let chapter: Chapter!
    let duration: Int!
    let isQuestionsRandomized: Bool!
    let numOfQuestionsPerPage: Int!
    let state: String!
    let totalScore: Int!
    let lessonId: Int!
    let studentSolved: Bool!
    let blooms: [String]!
    let gradingPeriodLock: Bool!
    let gradingPeriod: Any!
    let questions: [Questions]!
    let objectives: [Objectives]!
    let groupingStudents: [Any]!
    //    let courseGroupsQuiz: [CourseGroupsQuiz]?
    let hours: Int!
    let minutes: Int!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        startDate = dict["start_date"] as? String
        endDate = dict["end_date"] as? String
        description = dict["description"] as? String
        
        if let courseGroupsDictArray = dict["course_groups"] as? [[String: Any]] {
            courseGroups = courseGroupsDictArray.map { CourseGroups($0) }
        } else {
            courseGroups = nil
        }
        
        if let categoryDict = dict["category"] as? [String: Any] {
            category = Category(categoryDict)
        } else {
            category = nil
        }
        
        if let lessonDict = dict["lesson"] as? [String: Any] {
            lesson = Lesson(lessonDict)
        } else {
            lesson = nil
        }
        
        if let unitDict = dict["unit"] as? [String: Any] {
            unit = Unit(unitDict)
        } else {
            unit = nil
        }
        
        if let chapterDict = dict["chapter"] as? [String: Any] {
            chapter = Chapter(chapterDict)
        } else {
            chapter = nil
        }
        duration = dict["duration"] as? Int
        hours = dict["hours"] as? Int
        minutes = dict["minutes"] as? Int
        isQuestionsRandomized = dict["is_questions_randomized"] as? Bool
        numOfQuestionsPerPage = dict["num_of_questions_per_page"] as? Int
        state = dict["state"] as? String
        totalScore = dict["total_score"] as? Int
        lessonId = dict["lesson_id"] as? Int
        studentSolved = dict["student_solved"] as? Bool
        blooms = dict["blooms"] as? [String]
        gradingPeriodLock = dict["grading_period_lock"] as? Bool
        gradingPeriod = dict["grading_period"] as? Any
        if let questionsDictArray = dict["questions"] as? [[String: Any]] {
            questions = questionsDictArray.map { Questions($0) }
        } else {
            questions = nil
        }
        if let objectivesDictArray = dict["objectives"] as? [[String: Any]] {
            objectives = objectivesDictArray.map { Objectives($0) }
        } else {
            objectives = nil
        }
        groupingStudents = dict["grouping_students"] as? [Any]
        
    }
    
}

class CourseGroups {
    
    let name: String?
    let id: Int?
    let students: Int?
    
    init(_ dict: [String: Any]) {
        name = dict["name"] as? String
        id = dict["id"] as? Int
        students = dict["students"] as? Int
    }
    
}

class Category {
    
    let id: Int?
    let name: String?
    let weight: Int?
    let courseId: Any?
    let createdAt: String?
    let updatedAt: String?
    let gradingCategoryId: Int?
    let deletedAt: Any?
    let parentId: Any?
    let numeric: Bool?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        weight = dict["weight"] as? Int
        courseId = dict["course_id"] as? Any
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        gradingCategoryId = dict["grading_category_id"] as? Int
        deletedAt = dict["deleted_at"] as? Any
        parentId = dict["parent_id"] as? Any
        numeric = dict["numeric"] as? Bool
    }
    
}

class Lesson {
    
    let id: Int?
    let name: String?
    let unitId: Int?
    let description: Any?
    let date: Any?
    let order: Int?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: Any?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        unitId = dict["unit_id"] as? Int
        description = dict["description"] as? Any
        date = dict["date"] as? Any
        order = dict["order"] as? Int
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        deletedAt = dict["deleted_at"] as? Any
    }
    
}

class Unit {
    
    let id: Int?
    let name: String?
    let chapterId: Int?
    let description: Any?
    let order: Int?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: Any?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        chapterId = dict["chapter_id"] as? Int
        description = dict["description"] as? Any
        order = dict["order"] as? Int
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        deletedAt = dict["deleted_at"] as? Any
    }
    
}

class Chapter {
    
    let id: Int?
    let name: String?
    let courseId: Int?
    let description: Any?
    let order: Int?
    let createdAt: String?
    let updatedAt: String?
    let lock: Bool?
    let deletedAt: Any?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        courseId = dict["course_id"] as? Int
        description = dict["description"] as? Any
        order = dict["order"] as? Int
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        lock = dict["lock"] as? Bool
        deletedAt = dict["deleted_at"] as? Any
    }
    
}

class Objectives {
    
    let id: Int?
    let name: String?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
    }
    
}
