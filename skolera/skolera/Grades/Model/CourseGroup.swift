//
//	ClassGroup.swift
//
//	Create by Ismail Ahmed on 12/4/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CourseGroup : NSObject, NSCoding{

	var completedLessonsCount : Int!
	var courseId : Int!
	var courseName : String!
	var iconName : AnyObject!
	var id : Int!
	var lastCompletedLessonName : AnyObject!
	var lessonsCount : Int!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		completedLessonsCount = dictionary["completed_lessons_count"] as? Int
		courseId = dictionary["course_id"] as? Int
		courseName = dictionary["course_name"] as? String
        iconName = dictionary["icon_name"] as AnyObject
		id = dictionary["id"] as? Int
        lastCompletedLessonName = dictionary["last_completed_lesson_name"] as AnyObject
		lessonsCount = dictionary["lessons_count"] as? Int
		name = dictionary["name"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if completedLessonsCount != nil{
			dictionary["completed_lessons_count"] = completedLessonsCount
		}
		if courseId != nil{
			dictionary["course_id"] = courseId
		}
		if courseName != nil{
			dictionary["course_name"] = courseName
		}
		if iconName != nil{
			dictionary["icon_name"] = iconName
		}
		if id != nil{
			dictionary["id"] = id
		}
		if lastCompletedLessonName != nil{
			dictionary["last_completed_lesson_name"] = lastCompletedLessonName
		}
		if lessonsCount != nil{
			dictionary["lessons_count"] = lessonsCount
		}
		if name != nil{
			dictionary["name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         completedLessonsCount = aDecoder.decodeObject(forKey: "completed_lessons_count") as? Int
         courseId = aDecoder.decodeObject(forKey: "course_id") as? Int
         courseName = aDecoder.decodeObject(forKey: "course_name") as? String
        iconName = aDecoder.decodeObject(forKey: "icon_name") as AnyObject
         id = aDecoder.decodeObject(forKey: "id") as? Int
        lastCompletedLessonName = aDecoder.decodeObject(forKey: "last_completed_lesson_name") as AnyObject
         lessonsCount = aDecoder.decodeObject(forKey: "lessons_count") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if completedLessonsCount != nil{
			aCoder.encode(completedLessonsCount, forKey: "completed_lessons_count")
		}
		if courseId != nil{
			aCoder.encode(courseId, forKey: "course_id")
		}
		if courseName != nil{
			aCoder.encode(courseName, forKey: "course_name")
		}
		if iconName != nil{
			aCoder.encode(iconName, forKey: "icon_name")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lastCompletedLessonName != nil{
			aCoder.encode(lastCompletedLessonName, forKey: "last_completed_lesson_name")
		}
		if lessonsCount != nil{
			aCoder.encode(lessonsCount, forKey: "lessons_count")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}

	}

}
