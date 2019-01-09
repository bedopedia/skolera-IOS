//
//    CourseGradingPeriods.swift
//
//    Create by Yehia Beram on 20/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CourseGradingPeriods : NSObject, NSCoding{
    
    var endDate : String!
    var id : Int!
    var lock : Bool!
    var name : String!
    var publish : Bool!
    var startDate : String!
    var subGradingPeriodsAttributes : [CourseGradingPeriods]!
    var weight : Int!
    var isChild: Bool = false
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        endDate = dictionary["end_date"] as? String
        id = dictionary["id"] as? Int
        lock = dictionary["lock"] as? Bool
        name = dictionary["name"] as? String
        publish = dictionary["publish"] as? Bool
        startDate = dictionary["start_date"] as? String
        subGradingPeriodsAttributes = dictionary["sub_grading_periods_attributes"] as? [CourseGradingPeriods]
        weight = dictionary["weight"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if endDate != nil{
            dictionary["end_date"] = endDate
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lock != nil{
            dictionary["lock"] = lock
        }
        if name != nil{
            dictionary["name"] = name
        }
        if publish != nil{
            dictionary["publish"] = publish
        }
        if startDate != nil{
            dictionary["start_date"] = startDate
        }
        if subGradingPeriodsAttributes != nil{
            dictionary["sub_grading_periods_attributes"] = subGradingPeriodsAttributes
        }
        if weight != nil{
            dictionary["weight"] = weight
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lock = aDecoder.decodeObject(forKey: "lock") as? Bool
        name = aDecoder.decodeObject(forKey: "name") as? String
        publish = aDecoder.decodeObject(forKey: "publish") as? Bool
        startDate = aDecoder.decodeObject(forKey: "start_date") as? String
        subGradingPeriodsAttributes = aDecoder.decodeObject(forKey: "sub_grading_periods_attributes") as? [CourseGradingPeriods]
        weight = aDecoder.decodeObject(forKey: "weight") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lock != nil{
            aCoder.encode(lock, forKey: "lock")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if publish != nil{
            aCoder.encode(publish, forKey: "publish")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        if subGradingPeriodsAttributes != nil{
            aCoder.encode(subGradingPeriodsAttributes, forKey: "sub_grading_periods_attributes")
        }
        if weight != nil{
            aCoder.encode(weight, forKey: "weight")
        }
        
    }
    
}
