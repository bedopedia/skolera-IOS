//
//  Feedback.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on August 07, 2019
//
import Foundation

class SubmissionFeedback {
    
    let id: Int?
    let content: String?
    let ownerId: Int?
    let onId: Int?
    let onType: String?
    let toId: Int?
    let toType: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: Any?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        content = dict["content"] as? String
        ownerId = dict["owner_id"] as? Int
        onId = dict["on_id"] as? Int
        onType = dict["on_type"] as? String
        toId = dict["to_id"] as? Int
        toType = dict["to_type"] as? String
        createdAt = dict["created_at"] as? String
        updatedAt = dict["updated_at"] as? String
        deletedAt = dict["deleted_at"] as? Any
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["content"] = content
        jsonDict["owner_id"] = ownerId
        jsonDict["on_id"] = onId
        jsonDict["on_type"] = onType
        jsonDict["to_id"] = toId
        jsonDict["to_type"] = toType
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["deleted_at"] = deletedAt
        return jsonDict
    }
    
}
