//
//	Attendance.swift
//
//	Create by Ismail Ahmed on 30/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Attendance : NSObject, NSCoding{

	var comment : String!
	var date : Date!
	var id : Int!
	var status : String!
	var studentId : Int!
	var timetableSlotId : AnyObject!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
        comment = dictionary["comment"] as? String
		let time = dictionary["date"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        date = dateFormatter.date(from: time ?? "")
		id = dictionary["id"] as? Int
		status = dictionary["status"] as? String
		studentId = dictionary["student_id"] as? Int
		timetableSlotId = dictionary["timetable_slot_id"] as AnyObject
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if comment != nil{
			dictionary["comment"] = comment
		}
		if date != nil{
			dictionary["date"] = date
		}
		if id != nil{
			dictionary["id"] = id
		}
		if status != nil{
			dictionary["status"] = status
		}
		if studentId != nil{
			dictionary["student_id"] = studentId
		}
		if timetableSlotId != nil{
			dictionary["timetable_slot_id"] = timetableSlotId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         comment = aDecoder.decodeObject(forKey: "comment") as? String
         var time = aDecoder.decodeObject(forKey: "date") as? Double
         time = time! / 1000
         date = Date(timeIntervalSince1970: time!)
         id = aDecoder.decodeObject(forKey: "id") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? String
         studentId = aDecoder.decodeObject(forKey: "student_id") as? Int
         timetableSlotId = aDecoder.decodeObject(forKey: "timetable_slot_id") as AnyObject

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if comment != nil{
			aCoder.encode(comment, forKey: "comment")
		}
		if date != nil{
			aCoder.encode(date, forKey: "date")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if studentId != nil{
			aCoder.encode(studentId, forKey: "student_id")
		}
		if timetableSlotId != nil{
			aCoder.encode(timetableSlotId, forKey: "timetable_slot_id")
		}

	}

}
