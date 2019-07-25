//
//  QuizzesResponse.swift
//  skolera
//
//  Created by Yehia Beram on 7/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class QuizzesResponse {
    
    let quizzes: [FullQuiz]!
    let meta: Meta!
    
    init(_ dict: [String: Any]) {
        
        if let quizzesDictArray = dict["quizzes"] as? [[String: Any]] {
            quizzes = quizzesDictArray.map { FullQuiz($0) }
        } else {
            quizzes = []
        }
        
        if let metaDict = dict["meta"] as? [String: Any] {
            meta = Meta(fromDictionary: metaDict)
        } else {
            meta = Meta(fromDictionary: [:])
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["quizzes"] = quizzes?.map { $0.toDictionary() }
        jsonDict["meta"] = meta?.toDictionary()
        return jsonDict
    }
    
}
