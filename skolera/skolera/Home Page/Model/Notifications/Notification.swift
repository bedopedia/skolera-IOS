//
//	Notification.swift
//
//	Create by Ismail Ahmed on 31/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Notification : NSObject, NSCoding{

	var additionalParams : AdditionalParam!
	var createdAt : String!
	var from : AnyObject!
	var id : Int!
	var logo : String!
	var message : String!
	var params : Param!
	var seen : Bool!
	var text : String!
	var to : Parent!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let additionalParamsData = dictionary["additional_params"] as? [String:Any]{
			additionalParams = AdditionalParam(fromDictionary: additionalParamsData)
		}
		createdAt = dictionary["created_at"] as? String
		from = dictionary["from"] as AnyObject
		id = dictionary["id"] as? Int
		logo = dictionary["logo"] as? String
		message = dictionary["message"] as? String
		if let paramsData = dictionary["params"] as? [String:Any]{
			params = Param(fromDictionary: paramsData)
		}
		seen = dictionary["seen"] as? Bool
		text = dictionary["text"] as? String
		if let toData = dictionary["to"] as? [String:Any]{
			to = Parent(fromDictionary: toData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if additionalParams != nil{
			dictionary["additional_params"] = additionalParams.toDictionary()
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if from != nil{
			dictionary["from"] = from
		}
		if id != nil{
			dictionary["id"] = id
		}
		if logo != nil{
			dictionary["logo"] = logo
		}
		if message != nil{
			dictionary["message"] = message
		}
		if params != nil{
			dictionary["params"] = params.toDictionary()
		}
		if seen != nil{
			dictionary["seen"] = seen
		}
		if text != nil{
			dictionary["text"] = text
		}
		if to != nil{
			dictionary["to"] = to.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         additionalParams = aDecoder.decodeObject(forKey: "additional_params") as? AdditionalParam
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         from = aDecoder.decodeObject(forKey: "from") as AnyObject
         id = aDecoder.decodeObject(forKey: "id") as? Int
         logo = aDecoder.decodeObject(forKey: "logo") as? String
         message = aDecoder.decodeObject(forKey: "message") as? String
         params = aDecoder.decodeObject(forKey: "params") as? Param
         seen = aDecoder.decodeObject(forKey: "seen") as? Bool
         text = aDecoder.decodeObject(forKey: "text") as? String
         to = aDecoder.decodeObject(forKey: "to") as? Parent

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if additionalParams != nil{
			aCoder.encode(additionalParams, forKey: "additional_params")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if from != nil{
			aCoder.encode(from, forKey: "from")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if logo != nil{
			aCoder.encode(logo, forKey: "logo")
		}
		if message != nil{
			aCoder.encode(message, forKey: "message")
		}
		if params != nil{
			aCoder.encode(params, forKey: "params")
		}
		if seen != nil{
			aCoder.encode(seen, forKey: "seen")
		}
		if text != nil{
			aCoder.encode(text, forKey: "text")
		}
		if to != nil{
			aCoder.encode(to, forKey: "to")
		}

	}

}
