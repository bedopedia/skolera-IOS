//
//  AssignmentsResponse.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class AssignmentsResponse {
    
    let assignments: [FullAssignment]?
    let meta: Meta?
    
    init(_ dict: [String: Any]) {
        
        if let assignmentsDictArray = dict["assignments"] as? [[String: Any]] {
            assignments = assignmentsDictArray.map { FullAssignment($0) }
        } else {
            assignments = []
        }
        
        if let metaDict = dict["meta"] as? [String: Any] {
            meta = Meta(fromDictionary: metaDict)
        } else {
            meta = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["assignments"] = assignments?.map { $0.toDictionary() }
        jsonDict["meta"] = meta?.toDictionary()
        return jsonDict
    }
    
}
