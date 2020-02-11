//
//  ShortCourseGroup.swift
//  skolera
//
//  Created by Salma Medhat on 2/11/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import Foundation

class ShortCourseGroup {
    
    let id: Int?
    let courseId: Int?
    let courseName: String?
    
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        courseId = dict["course_id"] as? Int
        courseName = dict["course_name"] as? String
      
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["course_id"] = courseId
        jsonDict["course_name"] = courseName
        return jsonDict
    }
}
