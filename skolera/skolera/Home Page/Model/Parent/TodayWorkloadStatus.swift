//
//	TodayWorkloadStatu.swift
//
//	Create by Ismail Ahmed on 30/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TodayWorkloadStatus : NSObject, NSCoding{

	var assignmentsCount : Int!
	var attendanceStatus : String!
	var eventsCount : Int!
	var quizzesCount : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		assignmentsCount = dictionary["assignments_count"] as? Int
		attendanceStatus = dictionary["attendance_status"] as? String
		eventsCount = dictionary["events_count"] as? Int
		quizzesCount = dictionary["quizzes_count"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if assignmentsCount != nil{
			dictionary["assignments_count"] = assignmentsCount
		}
		if attendanceStatus != nil{
			dictionary["attendance_status"] = attendanceStatus
		}
		if eventsCount != nil{
			dictionary["events_count"] = eventsCount
		}
		if quizzesCount != nil{
			dictionary["quizzes_count"] = quizzesCount
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         assignmentsCount = aDecoder.decodeObject(forKey: "assignments_count") as? Int
         attendanceStatus = aDecoder.decodeObject(forKey: "attendance_status") as? String
         eventsCount = aDecoder.decodeObject(forKey: "events_count") as? Int
         quizzesCount = aDecoder.decodeObject(forKey: "quizzes_count") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if assignmentsCount != nil{
			aCoder.encode(assignmentsCount, forKey: "assignments_count")
		}
		if attendanceStatus != nil{
			aCoder.encode(attendanceStatus, forKey: "attendance_status")
		}
		if eventsCount != nil{
			aCoder.encode(eventsCount, forKey: "events_count")
		}
		if quizzesCount != nil{
			aCoder.encode(quizzesCount, forKey: "quizzes_count")
		}

	}

}
