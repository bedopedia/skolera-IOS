//
//  Events.swift
//  skolera
//
//  Created by Yehia Beram on 8/19/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class StudentEvent {
    
    let id: Int!
    let type: String!
    let endDate: Int!
    let startDate: Int!
    let description: String!
    let title: String!
    let ownerId: Int!
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        type = dict["type"] as? String
        endDate = dict["end_date"] as? Int
        startDate = dict["start_date"] as? Int
        description = dict["description"] as? String
        title = dict["title"] as? String
        ownerId = dict["owner_id"] as? Int
    }
    
}
