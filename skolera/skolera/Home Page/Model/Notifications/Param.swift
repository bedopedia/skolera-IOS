//
//	Param.swift
//
//	Create by Ismail Ahmed on 31/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Param : NSObject, NSCoding{

	var courseGroupId : Int!
	var courseId : Int!
	var courseName : String!
	var quizId : Int!
	var quizName : String!
	var studentId : Int!
	var studentName : String!
    var zoomMeetingId: Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		courseGroupId = dictionary["courseGroupId"] as? Int
		courseId = dictionary["courseId"] as? Int
		courseName = dictionary["courseName"] as? String
		quizId = dictionary["quizId"] as? Int
		quizName = dictionary["quizName"] as? String
		studentId = dictionary["studentId"] as? Int
		studentName = dictionary["studentName"] as? String
        zoomMeetingId = dictionary["zoomMeetingId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if courseGroupId != nil{
			dictionary["courseGroupId"] = courseGroupId
		}
		if courseId != nil{
			dictionary["courseId"] = courseId
		}
		if courseName != nil{
			dictionary["courseName"] = courseName
		}
		if quizId != nil{
			dictionary["quizId"] = quizId
		}
		if quizName != nil{
			dictionary["quizName"] = quizName
		}
		if studentId != nil{
			dictionary["studentId"] = studentId
		}
		if studentName != nil{
			dictionary["studentName"] = studentName
		}
        if zoomMeetingId != nil{
            dictionary["zoomMeetingId"] = zoomMeetingId
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         courseGroupId = aDecoder.decodeObject(forKey: "courseGroupId") as? Int
         courseId = aDecoder.decodeObject(forKey: "courseId") as? Int
         courseName = aDecoder.decodeObject(forKey: "courseName") as? String
         quizId = aDecoder.decodeObject(forKey: "quizId") as? Int
         quizName = aDecoder.decodeObject(forKey: "quizName") as? String
         studentId = aDecoder.decodeObject(forKey: "studentId") as? Int
         studentName = aDecoder.decodeObject(forKey: "studentName") as? String
         zoomMeetingId = aDecoder.decodeObject(forKey: "zoomMeetingId") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if courseGroupId != nil{
			aCoder.encode(courseGroupId, forKey: "courseGroupId")
		}
		if courseId != nil{
			aCoder.encode(courseId, forKey: "courseId")
		}
		if courseName != nil{
			aCoder.encode(courseName, forKey: "courseName")
		}
		if quizId != nil{
			aCoder.encode(quizId, forKey: "quizId")
		}
		if quizName != nil{
			aCoder.encode(quizName, forKey: "quizName")
		}
		if studentId != nil{
			aCoder.encode(studentId, forKey: "studentId")
		}
		if studentName != nil{
			aCoder.encode(studentName, forKey: "studentName")
		}
        if zoomMeetingId != nil{
            aCoder.encode(studentName, forKey: "zoomMeetingId")
        }

	}

}
