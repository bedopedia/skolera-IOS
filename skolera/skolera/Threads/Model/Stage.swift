//
//    Stage.swift
//
//    Create by Yehia Beram on 27/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Stage : NSObject, NSCoding{
    
    var createdAt : String!
    var deletedAt : AnyObject!
    var id : Int!
    var isDeleted : Bool!
    var isPreschool : Bool!
    var name : String!
    var sectionId : Int!
    var updatedAt : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        deletedAt = dictionary["deleted_at"] as? AnyObject
        id = dictionary["id"] as? Int
        isDeleted = dictionary["is_deleted"] as? Bool
        isPreschool = dictionary["is_preschool"] as? Bool
        name = dictionary["name"] as? String
        sectionId = dictionary["section_id"] as? Int
        updatedAt = dictionary["updated_at"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deletedAt != nil{
            dictionary["deleted_at"] = deletedAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if isPreschool != nil{
            dictionary["is_preschool"] = isPreschool
        }
        if name != nil{
            dictionary["name"] = name
        }
        if sectionId != nil{
            dictionary["section_id"] = sectionId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        deletedAt = aDecoder.decodeObject(forKey: "deleted_at") as? AnyObject
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? Bool
        isPreschool = aDecoder.decodeObject(forKey: "is_preschool") as? Bool
        name = aDecoder.decodeObject(forKey: "name") as? String
        sectionId = aDecoder.decodeObject(forKey: "section_id") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if deletedAt != nil{
            aCoder.encode(deletedAt, forKey: "deleted_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if isPreschool != nil{
            aCoder.encode(isPreschool, forKey: "is_preschool")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if sectionId != nil{
            aCoder.encode(sectionId, forKey: "section_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        
    }
    
}
