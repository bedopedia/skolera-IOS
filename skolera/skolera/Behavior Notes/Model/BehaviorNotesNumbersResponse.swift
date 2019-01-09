//
//	BehaviorNotesNumbersResponse.swift
//
//	Create by Ismail Ahmed on 28/4/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BehaviorNotesNumbersResponse : NSObject, NSCoding{

	var bad : Int!
	var good : Int!
	var other : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		bad = dictionary["bad"] as? Int
		good = dictionary["good"] as? Int
		other = dictionary["other"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if bad != nil{
			dictionary["bad"] = bad
		}
		if good != nil{
			dictionary["good"] = good
		}
		if other != nil{
			dictionary["other"] = other
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bad = aDecoder.decodeObject(forKey: "bad") as? Int
         good = aDecoder.decodeObject(forKey: "good") as? Int
         other = aDecoder.decodeObject(forKey: "other") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if bad != nil{
			aCoder.encode(bad, forKey: "bad")
		}
		if good != nil{
			aCoder.encode(good, forKey: "good")
		}
		if other != nil{
			aCoder.encode(other, forKey: "other")
		}

	}

}