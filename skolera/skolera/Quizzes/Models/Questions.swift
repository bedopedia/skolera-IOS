//
//  Questions.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 26, 2019
//
import Foundation

class Questions: Hashable {
    
    let id: Int?
    let body: String?
    let difficulty: String?
    let score: Int?
    let answersAttributes: [Answers]?
    let correctionStyle: Any?
    let type: String?
    let bloom: [String]?
    let files: Any?
    let uploadedFile: Any?
    let correctAnswersCount: Int?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        body = dict["body"] as? String
        difficulty = dict["difficulty"] as? String
        score = dict["score"] as? Int
        
        if let answersAttributesDictArray = dict["answers_attributes"] as? [[String: Any]] {
            answersAttributes = answersAttributesDictArray.map { Answers($0) }
        } else {
            answersAttributes = nil
        }
        correctionStyle = dict["correction_style"] as? Any
        type = dict["type"] as? String
        bloom = dict["bloom"] as? [String]
        files = dict["files"] as? Any
        uploadedFile = dict["uploaded_file"] as? Any
        correctAnswersCount = dict["correct_answers_count"] as? Int
    }
    
    static func == (lhs: Questions, rhs: Questions) -> Bool {
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
