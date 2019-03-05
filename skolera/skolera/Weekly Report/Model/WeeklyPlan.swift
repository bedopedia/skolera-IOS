//
//    WeeklyPlan.swift
//
//    Create by Yehia Beram on 4/3/2019
//    Copyright © 2019 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class WeeklyPlan : NSObject, NSCoding{
    
    var coursesCount : Int!
    var dailyNotes : [DailyNote]!
    var endDate : String!
    var id : Int!
    var level : Level!
    var levelId : Int!
    var startDate : String!
    var state : String!
    var weeklyNotes : [WeeklyNote]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        coursesCount = dictionary["courses_count"] as? Int
        dailyNotes = [DailyNote]()
        if let dailyNotesArray = dictionary["daily_notes"] as? [[String:Any]]{
            for dic in dailyNotesArray{
                let value = DailyNote(fromDictionary: dic)
                dailyNotes.append(value)
            }
        }
        endDate = dictionary["end_date"] as? String
        id = dictionary["id"] as? Int
        if let levelData = dictionary["level"] as? [String:Any]{
            level = Level(fromDictionary: levelData)
        }
        levelId = dictionary["level_id"] as? Int
        startDate = dictionary["start_date"] as? String
        state = dictionary["state"] as? String
        weeklyNotes = [WeeklyNote]()
        if let weeklyNotesArray = dictionary["weekly_notes"] as? [[String:Any]]{
            for dic in weeklyNotesArray{
                let value = WeeklyNote(fromDictionary: dic)
                weeklyNotes.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if coursesCount != nil{
            dictionary["courses_count"] = coursesCount
        }
        if dailyNotes != nil{
            var dictionaryElements = [[String:Any]]()
            for dailyNotesElement in dailyNotes {
                dictionaryElements.append(dailyNotesElement.toDictionary())
            }
            dictionary["daily_notes"] = dictionaryElements
        }
        if endDate != nil{
            dictionary["end_date"] = endDate
        }
        if id != nil{
            dictionary["id"] = id
        }
        if level != nil{
            dictionary["level"] = level.toDictionary()
        }
        if levelId != nil{
            dictionary["level_id"] = levelId
        }
        if startDate != nil{
            dictionary["start_date"] = startDate
        }
        if state != nil{
            dictionary["state"] = state
        }
        if weeklyNotes != nil{
            var dictionaryElements = [[String:Any]]()
            for weeklyNotesElement in weeklyNotes {
                dictionaryElements.append(weeklyNotesElement.toDictionary())
            }
            dictionary["weekly_notes"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        coursesCount = aDecoder.decodeObject(forKey: "courses_count") as? Int
        dailyNotes = aDecoder.decodeObject(forKey :"daily_notes") as? [DailyNote]
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        level = aDecoder.decodeObject(forKey: "level") as? Level
        levelId = aDecoder.decodeObject(forKey: "level_id") as? Int
        startDate = aDecoder.decodeObject(forKey: "start_date") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        weeklyNotes = aDecoder.decodeObject(forKey :"weekly_notes") as? [WeeklyNote]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if coursesCount != nil{
            aCoder.encode(coursesCount, forKey: "courses_count")
        }
        if dailyNotes != nil{
            aCoder.encode(dailyNotes, forKey: "daily_notes")
        }
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if level != nil{
            aCoder.encode(level, forKey: "level")
        }
        if levelId != nil{
            aCoder.encode(levelId, forKey: "level_id")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if weeklyNotes != nil{
            aCoder.encode(weeklyNotes, forKey: "weekly_notes")
        }
        
    }
    
}
