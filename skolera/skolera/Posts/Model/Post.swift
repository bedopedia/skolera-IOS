//
//  Post.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class Post {
    
    let id: Int?
    let content: String?
    let postableType: String?
    let postableId: Int?
    let createdAt: String?
    let updatedAt: String?
    let videoPreview: String?
    var comments: [PostComment]?
    let owner: PostOwner?
    let uploadedFiles: [UploadedFile]?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        content = dict["content"] as? String
        postableType = dict["postable_type"] as? String
        postableId = dict["postable_id"] as? Int
        createdAt = dict["created_at"] as? String
        
        updatedAt = dict["updated_at"] as? String
        videoPreview = dict["video_preview"] as? String
        
        if let ownerDict = dict["owner"] as? [String: Any] {
            owner = PostOwner(ownerDict)
        } else {
            owner = nil
        }
        
        if let commentsDictArray = dict["comments"] as? [[String: Any]] {
            comments = commentsDictArray.map { PostComment($0) }
        } else {
            comments = nil
        }
        
        if let uploadedFilesDictArray = dict["uploaded_files"] as? [[String: Any]] {
            uploadedFiles = uploadedFilesDictArray.map { UploadedFile($0) }
        } else {
            uploadedFiles = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["content"] = content
        jsonDict["postable_type"] = postableType
        jsonDict["postable_id"] = postableId
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["video_preview"] = videoPreview
        jsonDict["comments"] = comments
        jsonDict["owner"] = owner?.toDictionary()
        jsonDict["uploaded_files"] = uploadedFiles
        return jsonDict
    }

    
}
