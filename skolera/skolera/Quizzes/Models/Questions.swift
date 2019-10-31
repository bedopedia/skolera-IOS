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
    var type: QuestionTypes!
    let bloom: [String]!
    let files: Any!
    let uploadedFile: Any!
    let correctAnswersCount: Int!
    let numberOfCorrectAnswers: Int!
    var answers: [Answer]!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        body =  dict["body"] as? String
        difficulty = dict["difficulty"] as? String
        score = dict["score"] as? Int
        type = QuestionTypes(rawValue: dict["type"] as? String ?? "")
        correctionStyle = dict["correction_style"]
        bloom = dict["bloom"] as? [String]
        files = dict["files"] 
        uploadedFile = dict["uploaded_file"]
        correctAnswersCount = dict["correct_answers_count"] as? Int
        numberOfCorrectAnswers = dict["number_of_correct_answers"] as? Int
        if let answersAttributesDictArray = dict["answers_attributes"] as? [[String: Any]] {
            handleAnswerAttributesArray(answerAttributesArray: answersAttributesDictArray)
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
    
    func handleAnswersArray(answersArray: [[String: Any]]) {
        if let body = answersArray.first?["body"] as? String, !body.isEmpty {
            answers = answersArray.map { Answer($0) }
        } else {
            type = .multipleChoice
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
    
    func handleAnswerAttributesArray(answerAttributesArray: [[String: Any]]) {
        if let body = answerAttributesArray.first?["body"] as? String, !body.isEmpty {
            answers = answerAttributesArray.map { Answer($0) }
            if type == .match {
//                construct the options
                var optionsArray: [Option] = []
                for answer in answers {
                    let option = Option(["id": answer.id!,
                                        "body": answer.body!])
                    optionsArray.append(option)
                }
                answers.first?.options = optionsArray
            }
        } else {
            type = .multipleChoice
            var customizedAnswersArray: [Answer] = []
            var firstItem = answerAttributesArray.first
            if let isCorrect = firstItem?["is_correct"] as? Bool {
                firstItem?["body"] = "\(isCorrect)"
            }
            let firstAnswer = Answer(firstItem ?? [:])
            let isCorrect = firstAnswer.isCorrect ?? false
            firstAnswer.body = "\(isCorrect)"
            customizedAnswersArray.append(firstAnswer)
            let secondItem: [String: Any] = ["body": "\(!isCorrect)" ,
              "id": -firstAnswer.id,
              "question_id": firstAnswer.questionId ?? -1,
              "is_correct": !isCorrect
            ]
            let secondAnswer = Answer(secondItem)
            customizedAnswersArray.append(secondAnswer)
            answers = customizedAnswersArray
        }
    }
    
}
