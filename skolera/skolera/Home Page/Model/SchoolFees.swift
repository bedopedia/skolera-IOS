//
//  SchoolFees.swift
//  skolera
//
//  Created by Yehia Beram on 13/01/2021.
//  Copyright © 2021 Skolera. All rights reserved.
//

import Foundation

class SchoolFees {

    let id: Int?
    let name: String?
    let amount: String?
    let dueDate: String?
    let studentName: String?

    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        amount = dict["amount"] as? String
        dueDate = dict["due_date"] as? String
        studentName = dict["student_name"] as? String
    }

    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["amount"] = amount
        jsonDict["due_date"] = dueDate
        jsonDict["student_name"] = studentName
        return jsonDict
    }

}
