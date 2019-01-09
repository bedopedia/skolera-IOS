//
//	Config.swift
//
//	Create by Ismail Ahmed on 29/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Config : NSObject, NSCoding{

	var gradingSytemIsEnable : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		gradingSytemIsEnable = dictionary["grading_sytem_is_enable"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if gradingSytemIsEnable != nil{
			dictionary["grading_sytem_is_enable"] = gradingSytemIsEnable
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         gradingSytemIsEnable = aDecoder.decodeObject(forKey: "grading_sytem_is_enable") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if gradingSytemIsEnable != nil{
			aCoder.encode(gradingSytemIsEnable, forKey: "grading_sytem_is_enable")
		}

	}

}