//
//    Message.swift
//
//    Create by Yehia Beram on 20/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

class Message : NSObject, NSCoding{
    
    var attachmentUrl : String!
    var body : String!
    var createdAt : String!
    var ext : String!
    var filename : String!
    var id : Int!
    var threadId : Int!
    var updatedAt : String!
    var user: User!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        attachmentUrl = dictionary["attachment_url"] as? String
        body = dictionary["body"] as? String
        createdAt = dictionary["created_at"] as? String
        ext = dictionary["ext"] as? String
        filename = dictionary["filename"] as? String
        id = dictionary["id"] as? Int
        threadId = dictionary["thread_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
        if let userData = dictionary["sender_data"] as? [String:Any] {
            user = User(fromDictionary: userData)
        } else if let userData = dictionary["user"] as? [String: Any] {
            user = User(fromDictionary: userData)
        }
        if let uploadedFiles = dictionary["uploaded_files"] as? [[String: Any]], let uploadedFile = uploadedFiles.first, uploadedFile.count > 0 {
            debugPrint(uploadedFile)
            attachmentUrl = uploadedFile["url"] as? String
            filename = uploadedFile["name"] as? String
            let splittedArray = filename.split(separator: ".")
            ext = String(splittedArray.last ?? "") 
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if attachmentUrl != nil{
            dictionary["attachment_url"] = attachmentUrl
        }
        if body != nil{
            dictionary["body"] = body
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if ext != nil{
            dictionary["ext"] = ext
        }
        if filename != nil{
            dictionary["filename"] = filename
        }
        if id != nil{
            dictionary["id"] = id
        }
        if threadId != nil{
            dictionary["thread_id"] = threadId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if user != nil{
            dictionary["user"] = user.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        attachmentUrl = aDecoder.decodeObject(forKey: "attachment_url") as? String
        body = aDecoder.decodeObject(forKey: "body") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        ext = aDecoder.decodeObject(forKey: "ext") as? String
        filename = aDecoder.decodeObject(forKey: "filename") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        threadId = aDecoder.decodeObject(forKey: "thread_id") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        user = aDecoder.decodeObject(forKey: "user") as? User
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if attachmentUrl != nil{
            aCoder.encode(attachmentUrl, forKey: "attachment_url")
        }
        if body != nil{
            aCoder.encode(body, forKey: "body")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if ext != nil{
            aCoder.encode(ext, forKey: "ext")
        }
        if filename != nil{
            aCoder.encode(filename, forKey: "filename")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if threadId != nil{
            aCoder.encode(threadId, forKey: "thread_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if user != nil{
            aCoder.encode(user, forKey: "user")
        }
        
    }
    
}
