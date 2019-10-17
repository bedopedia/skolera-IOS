//
//  AnswersAttributes.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 26, 2019
//
import Foundation

class Answers {
    
    let id: Int!
    var body: String!
    let isCorrect: Bool!
    let createdAt: String!
    let updatedAt: String!
    let questionId: Int!
    let match: String!
    let deletedAt: Any!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        body = dict["body"] as? String
        isCorrect = dict["is_correct"] as? Bool
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        questionId = dict["question_id"] as? Int
        match = dict["match"] as? String
        deletedAt = dict["deleted_at"] as? Any
    }
    
}
