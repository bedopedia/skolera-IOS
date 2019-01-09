//
//	AdditionalParam.swift
//
//	Create by Ismail Ahmed on 31/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class AdditionalParam : NSObject, NSCoding{

	var studentId : Int!
	var studentNames : [String]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		studentId = dictionary["studentId"] as? Int
		studentNames = dictionary["studentNames"] as? [String]
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if studentId != nil{
			dictionary["studentId"] = studentId
		}
		if studentNames != nil{
			dictionary["studentNames"] = studentNames
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         studentId = aDecoder.decodeObject(forKey: "studentId") as? Int
         studentNames = aDecoder.decodeObject(forKey: "studentNames") as? [String]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if studentId != nil{
			aCoder.encode(studentId, forKey: "studentId")
		}
		if studentNames != nil{
			aCoder.encode(studentNames, forKey: "studentNames")
		}

	}

}