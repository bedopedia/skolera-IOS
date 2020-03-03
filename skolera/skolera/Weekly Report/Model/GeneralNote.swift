//
//  GeneralNote.swift
//  skolera
//
//  Created by Salma Medhat on 2/13/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class GeneralNote {

    let id: Int
    let title: String
    let description: String
    let weeklyPlanId: Int
    let createdAt: String
    let updatedAt: String
    let image: String?

    init(_ dict: [String: Any]) {
        id = dict["id"] as! Int
        title = dict["title"] as! String
        description = dict["description"] as! String
        weeklyPlanId = dict["weekly_plan_id"] as! Int
        createdAt = dict["created_at"] as! String
        updatedAt = dict["updated_at"] as! String
        image = (dict["image"] as? [String: Any])?["url"] as? String
    }

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["title"] = title
        jsonDict["description"] = description
        jsonDict["weekly_plan_id"] = weeklyPlanId
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        return jsonDict
    }

}
