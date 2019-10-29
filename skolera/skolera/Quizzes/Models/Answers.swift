//
//  AnswersAttributes.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 26, 2019
//
import Foundation

class Answer: Hashable {
    
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    let id: Int!
    let questionId: Int!
    var body: String!
    var isCorrect: Bool!
    let createdAt: String!
    let updatedAt: String!
    let match: String!
    let deletedAt: Any!
    let options: [Option]!
    let matches: [String]!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        body = dict["body"] as? String
        isCorrect = dict["is_correct"] as? Bool
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        questionId = dict["question_id"] as? Int
        match = dict["match"] as? String
        deletedAt = dict["deleted_at"] as? Any
        if let optionsDictArray = dict["options"] as? [[String: Any]] {
            options = optionsDictArray.map { Option($0) }
        } else {
            options = nil
        }
        matches = dict["matches"] as? [String]
    }
    
}

class Option: Hashable {
    static func == (lhs: Option, rhs: Option) -> Bool {
        lhs.id == rhs.id
    }
    let id: Int!
    let questionId: Int!
    let body: String!

    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        questionId = dict["question_id"] as? Int
        body = dict["body"] as? String
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
