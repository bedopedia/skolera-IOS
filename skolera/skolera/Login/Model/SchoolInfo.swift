//
//	SchoolInfo.swift
//
//	Create by Ismail Ahmed on 29/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class SchoolInfo : NSObject, NSCoding{

	var avatarUrl : String!
	var config : Config!
	var defaultConfigs : [String]!
	var gaTrackingId : String!
	var id : Int!
	var name : String!
	var schoolDescription : String!
    var headerUrl: String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		avatarUrl = dictionary["avatar_url"] as? String
		if let configData = dictionary["config"] as? [String:Any]{
			config = Config(fromDictionary: configData)
		}
		defaultConfigs = dictionary["default_configs"] as? [String]
		gaTrackingId = dictionary["ga_tracking_id"] as? String
		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		schoolDescription = dictionary["school_description"] as? String
        headerUrl = dictionary["header_url"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if avatarUrl != nil{
			dictionary["avatar_url"] = avatarUrl
		}
		if config != nil{
			dictionary["config"] = config.toDictionary()
		}
		if defaultConfigs != nil{
			dictionary["default_configs"] = defaultConfigs
		}
		if gaTrackingId != nil{
			dictionary["ga_tracking_id"] = gaTrackingId
		}
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if schoolDescription != nil{
			dictionary["school_description"] = schoolDescription
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         avatarUrl = aDecoder.decodeObject(forKey: "avatar_url") as? String
         config = aDecoder.decodeObject(forKey: "config") as? Config
         defaultConfigs = aDecoder.decodeObject(forKey: "default_configs") as? [String]
         gaTrackingId = aDecoder.decodeObject(forKey: "ga_tracking_id") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         schoolDescription = aDecoder.decodeObject(forKey: "school_description") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if avatarUrl != nil{
			aCoder.encode(avatarUrl, forKey: "avatar_url")
		}
		if config != nil{
			aCoder.encode(config, forKey: "config")
		}
		if defaultConfigs != nil{
			aCoder.encode(defaultConfigs, forKey: "default_configs")
		}
		if gaTrackingId != nil{
			aCoder.encode(gaTrackingId, forKey: "ga_tracking_id")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if schoolDescription != nil{
			aCoder.encode(schoolDescription, forKey: "school_description")
		}

	}

}
