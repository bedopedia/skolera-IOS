//
//    DailyNote.swift
//
//    Create by Yehia Beram on 3/3/2019
//    Copyright © 2019 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class DailyNote : NSObject, NSCoding{
    
    var activities : String!
    var classWork : String!
    var date : String!
    var homework : String!
    var id : Int!
    var title : String!
    var weeklyPlanId : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        activities = dictionary["activities"] as? String
        classWork = dictionary["class_work"] as? String
        date = dictionary["date"] as? String
        homework = dictionary["homework"] as? String
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        weeklyPlanId = dictionary["weekly_plan_id"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if activities != nil{
            dictionary["activities"] = activities
        }
        if classWork != nil{
            dictionary["class_work"] = classWork
        }
        if date != nil{
            dictionary["date"] = date
        }
        if homework != nil{
            dictionary["homework"] = homework
        }
        if id != nil{
            dictionary["id"] = id
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
        activities = aDecoder.decodeObject(forKey: "activities") as? String
        classWork = aDecoder.decodeObject(forKey: "class_work") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
        homework = aDecoder.decodeObject(forKey: "homework") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        weeklyPlanId = aDecoder.decodeObject(forKey: "weekly_plan_id") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if activities != nil{
            aCoder.encode(activities, forKey: "activities")
        }
        if classWork != nil{
            aCoder.encode(classWork, forKey: "class_work")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if homework != nil{
            aCoder.encode(homework, forKey: "homework")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if weeklyPlanId != nil{
            aCoder.encode(weeklyPlanId, forKey: "weekly_plan_id")
        }
        
    }
    
}
