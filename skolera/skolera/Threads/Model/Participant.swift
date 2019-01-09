//
//    Participant.swift
//
//    Create by Yehia Beram on 20/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Participant : NSObject, NSCoding{
    
    var name : String!
    var threadId : Int!
    var userAvatarUrl : String!
    var userId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        threadId = dictionary["thread_id"] as? Int
        userAvatarUrl = dictionary["user_avatar_url"] as? String
        userId = dictionary["user_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if threadId != nil{
            dictionary["thread_id"] = threadId
        }
        if userAvatarUrl != nil{
            dictionary["user_avatar_url"] = userAvatarUrl
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as? String
        threadId = aDecoder.decodeObject(forKey: "thread_id") as? Int
        userAvatarUrl = aDecoder.decodeObject(forKey: "user_avatar_url") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if threadId != nil{
            aCoder.encode(threadId, forKey: "thread_id")
        }
        if userAvatarUrl != nil{
            aCoder.encode(userAvatarUrl, forKey: "user_avatar_url")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        
    }
    
}
