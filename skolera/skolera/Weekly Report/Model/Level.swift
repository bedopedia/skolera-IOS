//
//    Level.swift
//
//    Create by Yehia Beram on 3/3/2019
//    Copyright © 2019 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Level : NSObject, NSCoding{
    
    var id : Int!
    var levelType : String!
    var name : String!
    var slotsCount : Int!
    var stageId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        levelType = dictionary["level_type"] as? String
        name = dictionary["name"] as? String
        slotsCount = dictionary["slots_count"] as? Int
        stageId = dictionary["stage_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if levelType != nil{
            dictionary["level_type"] = levelType
        }
        if name != nil{
            dictionary["name"] = name
        }
        if slotsCount != nil{
            dictionary["slots_count"] = slotsCount
        }
        if stageId != nil{
            dictionary["stage_id"] = stageId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? Int
        levelType = aDecoder.decodeObject(forKey: "level_type") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        slotsCount = aDecoder.decodeObject(forKey: "slots_count") as? Int
        stageId = aDecoder.decodeObject(forKey: "stage_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if levelType != nil{
            aCoder.encode(levelType, forKey: "level_type")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if slotsCount != nil{
            aCoder.encode(slotsCount, forKey: "slots_count")
        }
        if stageId != nil{
            aCoder.encode(stageId, forKey: "stage_id")
        }
        
    }
    
}
