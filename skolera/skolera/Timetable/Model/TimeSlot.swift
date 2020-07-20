//
//	TimeSlot.swift
//
//	Create by Ismail Ahmed on 22/4/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TimeSlot : NSObject, NSCoding{
    
    var courseName : String!
    var day : String!
    var from : Date!
    var id : Int!
    var schoolUnit : String!
    var slotNo : Int!
    var to : Date!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        debugPrint(dictionary)
        courseName = dictionary["course_name"] as? String
        day = dictionary["day"] as? String
        id = dictionary["id"] as? Int
        schoolUnit = dictionary["school_unit"] as? String
        slotNo = dictionary["slot_no"] as? Int
        guard let fromDateString = dictionary["from"] as? String, let toDateString = dictionary["to"] as? String else { return }
        from = fromDateString.toDate("yyyy-MM-dd HH:mm:ss", region: .current)?.date
        to = toDateString.toDate("yyyy-MM-dd HH:mm:ss", region: .current)?.date
//        let dateFormatterFrom = DateFormatter()
//        dateFormatterFrom.locale = Locale(identifier: "en")
//        dateFormatterFrom.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let dateFrom = dateFormatterFrom.date(from: (dictionary["from"] as? String)!)!
//        let dateTo = dateFormatterFrom.date(from: (dictionary["to"] as? String)!)!
//        dateFormatterFrom.dateFormat = "HH:mm:ss"
//        let dateStringfrom = dateFormatterFrom.string(from: dateFrom)
//        let dateStringTo = dateFormatterFrom.string(from: dateTo)
//
//        let dateFormatterTo = DateFormatter()
//        dateFormatterTo.locale = Locale(identifier: "en")
//        dateFormatterTo.dateFormat = "HH:mm:ss"
//        from = dateFormatterTo.date(from: dateStringfrom)!
//        to = dateFormatterTo.date(from: dateStringTo)!
        
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if courseName != nil{
            dictionary["course_name"] = courseName
        }
        if day != nil{
            dictionary["day"] = day
        }
        if from != nil{
            dictionary["from"] = from
        }
        if id != nil{
            dictionary["id"] = id
        }
        if schoolUnit != nil{
            dictionary["school_unit"] = schoolUnit
        }
        if slotNo != nil{
            dictionary["slot_no"] = slotNo
        }
        if to != nil{
            dictionary["to"] = to
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        courseName = aDecoder.decodeObject(forKey: "course_name") as? String
        day = aDecoder.decodeObject(forKey: "day") as? String
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        from = dateFormatter.date(from: (aDecoder.decodeObject(forKey: "from") as? String)!)!
        to = dateFormatter.date(from: (aDecoder.decodeObject(forKey: "to") as? String)!)!
        id = aDecoder.decodeObject(forKey: "id") as? Int
        schoolUnit = aDecoder.decodeObject(forKey: "school_unit") as? String
        slotNo = aDecoder.decodeObject(forKey: "slot_no") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if courseName != nil{
            aCoder.encode(courseName, forKey: "course_name")
        }
        if day != nil{
            aCoder.encode(day, forKey: "day")
        }
        if from != nil{
            aCoder.encode(from, forKey: "from")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if schoolUnit != nil{
            aCoder.encode(schoolUnit, forKey: "school_unit")
        }
        if slotNo != nil{
            aCoder.encode(slotNo, forKey: "slot_no")
        }
        if to != nil{
            aCoder.encode(to, forKey: "to")
        }
        
    }
    
}
