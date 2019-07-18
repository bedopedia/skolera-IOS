//
//  PostCourse.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class PostCourse {
    
    let id: Int?
    let name: String?
    let courseId: Int?
    let courseName: String?
    let postsCount: Int?
    let post: Post?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        name = dict["name"] as? String
        courseId = dict["course_id"] as? Int
        courseName = dict["course_name"] as? String
        postsCount = dict["posts_count"] as? Int
        
        if let postsDict = dict["posts"] as? [String: Any] {
            post = Post(postsDict)
        } else {
            post = nil
        }
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["name"] = name
        jsonDict["course_id"] = courseId
        jsonDict["course_name"] = courseName
        jsonDict["posts_count"] = postsCount
        jsonDict["posts"] = post?.toDictionary()
        return jsonDict
    }
    
}
