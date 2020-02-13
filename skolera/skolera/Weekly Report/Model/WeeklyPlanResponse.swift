//
//  WeeklyPlanResponse.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on March 03, 2019
//
import Foundation

class WeeklyPlanResponse {
    
        let weeklyPlan: [WeeklyPlan]

        init(_ dict: [String: Any]) {

            if let weeklyPlanDictArray = dict["weekly_plan"] as? [[String: Any]] {
                weeklyPlan = weeklyPlanDictArray.map { WeeklyPlan($0) }
            } else {
                weeklyPlan = []
            }
        }

        func toDictionary() -> [String: Any] {
            var jsonDict = [String: Any]()
            jsonDict["weekly_plan"] = weeklyPlan.map { $0.toDictionary() }
            return jsonDict
        }

    }
