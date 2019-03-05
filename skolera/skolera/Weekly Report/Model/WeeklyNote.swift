//
//    WeeklyNote.swift
//
//    Create by Yehia Beram on 4/3/2019
//    Copyright © 2019 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class WeeklyNote : NSObject, NSCoding{
    
    var descriptionField : String!
    var id : Int!
    var imageUrl : String!
    var title : String!
    var weeklyPlanId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        descriptionField = dictionary["description"] as? String
        id = dictionary["id"] as? Int
        imageUrl = dictionary["image_url"] as? String
        title = dictionary["title"] as? String
        weeklyPlanId = dictionary["weekly_plan_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if id != nil{
            dictionary["id"] = id
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if title != nil{
            dictionary["title"] = title
        }
        if weeklyPlanId != nil{
            dictionary["weekly_plan_id"] = weeklyPlanId
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        imageUrl = aDecoder.decodeObject(forKey: "image_url") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        weeklyPlanId = aDecoder.decodeObject(forKey: "weekly_plan_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "image_url")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if weeklyPlanId != nil{
            aCoder.encode(weeklyPlanId, forKey: "weekly_plan_id")
        }
        
    }
    
}
