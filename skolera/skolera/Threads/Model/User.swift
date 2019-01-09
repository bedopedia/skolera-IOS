//
//    User.swift
//
//    Create by Yehia Beram on 20/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class User : NSObject, NSCoding{
    
    var actableId : Int!
    var avatarUrl : String!
    var firstname : String!
    var gender : String!
    var id : Int!
    var lastname : String!
    var name : String!
    var nameWithTitle : String!
    var thumbUrl : String!
    var userType : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        actableId = dictionary["actable_id"] as? Int
        avatarUrl = dictionary["avatar_url"] as? String
        firstname = dictionary["firstname"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? Int
        lastname = dictionary["lastname"] as? String
        name = dictionary["name"] as? String
        nameWithTitle = dictionary["name_with_title"] as? String
        thumbUrl = dictionary["thumb_url"] as? String
        userType = dictionary["user_type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if actableId != nil{
            dictionary["actable_id"] = actableId
        }
        if avatarUrl != nil{
            dictionary["avatar_url"] = avatarUrl
        }
        if firstname != nil{
            dictionary["firstname"] = firstname
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastname != nil{
            dictionary["lastname"] = lastname
        }
        if name != nil{
            dictionary["name"] = name
        }
        if nameWithTitle != nil{
            dictionary["name_with_title"] = nameWithTitle
        }
        if thumbUrl != nil{
            dictionary["thumb_url"] = thumbUrl
        }
        if userType != nil{
            dictionary["user_type"] = userType
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        actableId = aDecoder.decodeObject(forKey: "actable_id") as? Int
        avatarUrl = aDecoder.decodeObject(forKey: "avatar_url") as? String
        firstname = aDecoder.decodeObject(forKey: "firstname") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastname = aDecoder.decodeObject(forKey: "lastname") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        nameWithTitle = aDecoder.decodeObject(forKey: "name_with_title") as? String
        thumbUrl = aDecoder.decodeObject(forKey: "thumb_url") as? String
        userType = aDecoder.decodeObject(forKey: "user_type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if actableId != nil{
            aCoder.encode(actableId, forKey: "actable_id")
        }
        if avatarUrl != nil{
            aCoder.encode(avatarUrl, forKey: "avatar_url")
        }
        if firstname != nil{
            aCoder.encode(firstname, forKey: "firstname")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastname != nil{
            aCoder.encode(lastname, forKey: "lastname")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if nameWithTitle != nil{
            aCoder.encode(nameWithTitle, forKey: "name_with_title")
        }
        if thumbUrl != nil{
            aCoder.encode(thumbUrl, forKey: "thumb_url")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "user_type")
        }
        
    }
    
}
