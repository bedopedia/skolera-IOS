//
//  PostComment.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation


class PostComment {
    
    let id: Int?
    let content: String?
    let postId: Int?
    let createdAt: String?
    let updatedAt: String?
    let owner: PostOwner?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        content = dict["content"] as? String
        postId = dict["post_id"] as? Int
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        
        if let ownerDict = dict["owner"] as? [String: Any] {
            owner = PostOwner(ownerDict)
        } else {
            owner = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["content"] = content
        jsonDict["post_id"] = postId
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["owner"] = owner?.toDictionary()
        return jsonDict
    }
    
}
