//
//  Students.swift
//  skolera
//
//  Created by Rana Hossam on 9/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class Students {
    
    let childId: Int?
    let name: String?
    let avatarUrl: String?
    
    init(_ dict: [String: Any]) {
        childId = dict["child_id"] as? Int
        name = dict["name"] as? String
        avatarUrl = dict["avatar_url"] as? String
    }
    
}
