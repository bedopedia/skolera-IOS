//
//  UploadedFile.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class UploadedFile {
    
    let id: Int?
    let downloadName: String?
    let contentType: String?
    let name: String?
    let description: String?
    let fileSize: Int?
    let downloadsNumber: Int?
    let createdAt: Int?
    let updatedAt: String?
    let originalFilename: String?
    let extensionField: String?
    let fileIdentifier: String?
    let url: String?
    let uploadType: String?
    let creatorName: String?
    
    init(_ dict: [String: Any]) {
        id = dict["id"] as? Int
        downloadName = dict["download_name"] as? String
        contentType = dict["content_type"] as? String
        name = dict["name"] as? String
        description = dict["description"] as? String
        fileSize = dict["file_size"] as? Int
        downloadsNumber = dict["downloads_number"] as? Int
        createdAt = dict["created_at"] as? Int
        updatedAt = dict["updated_at"] as? String
        originalFilename = dict["original_filename"] as? String
        extensionField = dict["extension"] as? String
        fileIdentifier = dict["file_identifier"] as? String
        url = dict["url"] as? String
        uploadType = dict["upload_type"] as? String
        creatorName = dict["creator_name"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var jsonDict = [String: Any]()
        jsonDict["id"] = id
        jsonDict["download_name"] = downloadName
        jsonDict["content_type"] = contentType
        jsonDict["name"] = name
        jsonDict["description"] = description
        jsonDict["file_size"] = fileSize
        jsonDict["downloads_number"] = downloadsNumber
        jsonDict["created_at"] = createdAt
        jsonDict["updated_at"] = updatedAt
        jsonDict["original_filename"] = originalFilename
        jsonDict["extension"] = extensionField
        jsonDict["file_identifier"] = fileIdentifier
        jsonDict["url"] = url
        jsonDict["upload_type"] = uploadType
        jsonDict["creator_name"] = creatorName
        return jsonDict
    }
    
}
