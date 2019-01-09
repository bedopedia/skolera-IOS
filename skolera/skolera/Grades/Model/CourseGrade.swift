//
//	CourseGrade.swift
//
//	Create by Ismail Ahmed on 5/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CourseGrade : NSObject, NSCoding{

	var courseId : Int!
	var grade : Grade!
	var icon : String!
	var name : String!
	var percentage : Int!
	var totalGrade : String!
    var courseGroup : CourseGroup!
    var hideGrade: Bool = false

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		courseId = dictionary["course_id"] as? Int
        if let gradeData = dictionary["grade"] as? [String:Any]{
            grade = Grade(fromDictionary: gradeData)
        }
		icon = dictionary["icon"] as? String
		name = dictionary["name"] as? String
		percentage = dictionary["percentage"] as? Int
		totalGrade = dictionary["total_grade"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if courseId != nil{
			dictionary["course_id"] = courseId
		}
        if grade != nil{
            dictionary["grade"] = grade.toDictionary()
        }
		if icon != nil{
			dictionary["icon"] = icon
		}
		if name != nil{
			dictionary["name"] = name
		}
		if percentage != nil{
			dictionary["percentage"] = percentage
		}
		if totalGrade != nil{
			dictionary["total_grade"] = totalGrade
		}
        if courseGroup != nil{
            dictionary ["course_group"] = courseGroup
        }
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         courseId = aDecoder.decodeObject(forKey: "course_id") as? Int
         grade = aDecoder.decodeObject(forKey: "grade") as? Grade
         icon = aDecoder.decodeObject(forKey: "icon") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         percentage = aDecoder.decodeObject(forKey: "percentage") as? Int
         totalGrade = aDecoder.decodeObject(forKey: "total_grade") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if courseId != nil{
			aCoder.encode(courseId, forKey: "course_id")
		}
		if grade != nil{
			aCoder.encode(grade, forKey: "grade")
		}
		if icon != nil{
			aCoder.encode(icon, forKey: "icon")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if percentage != nil{
			aCoder.encode(percentage, forKey: "percentage")
		}
		if totalGrade != nil{
			aCoder.encode(totalGrade, forKey: "total_grade")
		}
        if courseGroup != nil{
            aCoder.encode(courseGroup, forKey: "course_group")
        }

	}

}
