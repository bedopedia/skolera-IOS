//
//  Questions.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on September 26, 2019
//
import Foundation

class Questions: Hashable {
    
    let id: Int!
    let body: String!
    let difficulty: String!
    let score: Int!
//    let answersAttributes: [Answer]!
    let correctionStyle: Any!
    var type: String!
    let bloom: [String]!
    let files: Any!
    let uploadedFile: Any!
    let correctAnswersCount: Int!
    let numberOfCorrectAnswers: Int!
    var answers: [Answer]!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        body = dict["body"] as? String
        difficulty = dict["difficulty"] as? String
        score = dict["score"] as? Int
        type = dict["type"] as? String
        correctionStyle = dict["correction_style"]
        bloom = dict["bloom"] as? [String]
        files = dict["files"] 
        uploadedFile = dict["uploaded_file"]
        correctAnswersCount = dict["correct_answers_count"] as? Int
        numberOfCorrectAnswers = dict["number_of_correct_answers"] as? Int
        if let answersAttributesDictArray = dict["answers_attributes"] as? [[String: Any]] {
            answers = answersAttributesDictArray.map { Answer($0) }
        } else if let answersDictArray = dict["answers"] as? [[String: Any]] {
            self.handleAnswersArray(answersArray: answersDictArray)
        }  else {
            if let matchAnswer = dict["answers"] as? [String: Any] {
                answers = []
                answers.append(Answer.init(["options" : matchAnswer["options"],
                                             "matches": matchAnswer["matches"]]))
            } else {
                answers = nil
            }
        }
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
    
    func handleAnswersArray(answersArray: [[String: Any]]){
        if let body = answersArray.first?["body"] as? String, !body.isEmpty {
            answers = answersArray.map { Answer($0) }
        } else {
            type = "MultipleChoice"
            var firstItem = answersArray.first
            firstItem?["body"] = "true"
            let firstAnswer = Answer(firstItem ?? [:])
            var customizedAnswersArray: [Answer] = []
            customizedAnswersArray.append(firstAnswer)
            let secondItem: [String: Any] = ["body": "false",
                              "id": -firstAnswer.id,
                              "question_id": firstAnswer.questionId ?? -1
                            ]
            customizedAnswersArray.append(Answer(secondItem))
            answers = customizedAnswersArray
        }
    }
    
}
