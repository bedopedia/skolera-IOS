//
//	NotifcationResponse.swift
//
//	Create by Ismail Ahmed on 31/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class NotifcationResponse : NSObject, NSCoding{

	var meta : Meta!
	var notifications : [Notification]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		if let metaData = dictionary["meta"] as? [String:Any]{
			meta = Meta(fromDictionary: metaData)
		}
		notifications = [Notification]()
		if let notificationsArray = dictionary["notifications"] as? [[String:Any]]{
			for dic in notificationsArray{
				let value = Notification(fromDictionary: dic)
				notifications.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if meta != nil{
			dictionary["meta"] = meta.toDictionary()
		}
		if notifications != nil{
			var dictionaryElements = [[String:Any]]()
			for notificationsElement in notifications {
				dictionaryElements.append(notificationsElement.toDictionary())
			}
			dictionary["notifications"] = dictionaryElements
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         meta = aDecoder.decodeObject(forKey: "meta") as? Meta
         notifications = aDecoder.decodeObject(forKey :"notifications") as? [Notification]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if meta != nil{
			aCoder.encode(meta, forKey: "meta")
		}
		if notifications != nil{
			aCoder.encode(notifications, forKey: "notifications")
		}

	}

}