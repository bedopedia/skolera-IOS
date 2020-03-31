//
//  GradingPeriod.swift
//  skolera
//
//  Created by Salma Medhat on 2/11/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GradingPeriod {

    let id: Int
    let name: String
    let startDate: String
    let endDate: String
    let subGradingPeriodsAttributes: [GradingPeriod]
    let publish: Bool
    let lock: Bool

    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        name = dict["name"] as! String
        startDate = dict["start_date"] as! String
        endDate = dict["end_date"] as! String
        
        if let subGradingPeriodsAttributesDictArray = dict["sub_grading_periods_attributes"] as? [[String: Any]] {
            subGradingPeriodsAttributes = subGradingPeriodsAttributesDictArray.map { GradingPeriod($0) }
        } else {
            subGradingPeriodsAttributes = []
        }
        
        publish = dict["publish"] as? Bool ?? true
        lock = dict["lock"] as? Bool ?? false
    }

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["start_date"] = startDate
        jsonDict["end_date"] = endDate
        jsonDict["sub_grading_periods_attributes"] = subGradingPeriodsAttributes.map { $0.toDictionary() }
        jsonDict["publish"] = publish
        jsonDict["lock"] = lock
        return jsonDict
    }

}
