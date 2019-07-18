//
//  PostOwner.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class PostOwner {
    
    let id: Int?
    let firstname: String?
    let lastname: String?
    let avatarUrl: String?
    let thumbUrl: String?
    let userType: String?
    let name: String?
    let gender: String?
    let nameWithTitle: String?
    let actableId: Int?
    let userId: Int?
    let passwordChanged: Bool?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        firstname = dict["firstname"] as? String
        lastname = dict["lastname"] as? String
        avatarUrl = dict["avatar_url"] as? String
        thumbUrl = dict["thumb_url"] as? String
        userType = dict["user_type"] as? String
        name = dict["name"] as? String
        gender = dict["gender"] as? String
        nameWithTitle = dict["name_with_title"] as? String
        actableId = dict["actable_id"] as? Int
        userId = dict["user_id"] as? Int
        passwordChanged = dict["password_changed"] as? Bool
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["firstname"] = firstname
        jsonDict["lastname"] = lastname
        jsonDict["avatar_url"] = avatarUrl
        jsonDict["thumb_url"] = thumbUrl
        jsonDict["user_type"] = userType
        jsonDict["name"] = name
        jsonDict["gender"] = gender
        jsonDict["name_with_title"] = nameWithTitle
        jsonDict["actable_id"] = actableId
        jsonDict["user_id"] = userId
        jsonDict["password_changed"] = passwordChanged
        return jsonDict
    }
    
}
