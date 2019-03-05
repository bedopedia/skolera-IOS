//
//  WeeklyPlanResponse.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on March 03, 2019
//
import Foundation

class WeeklyPlanResponse : NSObject, NSCoding{
    
    var meta : Meta!
    var weeklyPlans : [WeeklyPlan]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let metaData = dictionary["meta"] as? [String:Any]{
            meta = Meta(fromDictionary: metaData)
        }
        weeklyPlans = [WeeklyPlan]()
        if let weeklyPlansArray = dictionary["weekly_plans"] as? [[String:Any]]{
            for dic in weeklyPlansArray{
                let value = WeeklyPlan(fromDictionary: dic)
                weeklyPlans.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if meta != nil{
            dictionary["meta"] = meta.toDictionary()
        }
        if weeklyPlans != nil{
            var dictionaryElements = [[String:Any]]()
            for weeklyPlansElement in weeklyPlans {
                dictionaryElements.append(weeklyPlansElement.toDictionary())
            }
            dictionary["weekly_plans"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        meta = aDecoder.decodeObject(forKey: "meta") as? Meta
        weeklyPlans = aDecoder.decodeObject(forKey :"weekly_plans") as? [WeeklyPlan]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if meta != nil{
            aCoder.encode(meta, forKey: "meta")
        }
        if weeklyPlans != nil{
            aCoder.encode(weeklyPlans, forKey: "weekly_plans")
        }
        
    }
    
}
