//
//  FileModel.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class FileModel {
    
    let url: String?
    
    init(_ dict: [String: Any]) {
        url = dict["url"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["url"] = url
        return jsonDict
    }
    
}
