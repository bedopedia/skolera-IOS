//
//	BehaviorNotesResponse.swift
//
//	Create by Ismail Ahmed on 28/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BehaviorNotesResponse : NSObject, NSCoding{

	var behaviorNotes : [BehaviorNote]!
	var meta : BehaviorNotesResponseMeta!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		behaviorNotes = [BehaviorNote]()
		if let behaviorNotesArray = dictionary["behavior_notes"] as? [[String:Any]]{
			for dic in behaviorNotesArray{
				let value = BehaviorNote(fromDictionary: dic)
				behaviorNotes.append(value)
			}
		}
		if let metaData = dictionary["meta"] as? [String:Any]{
			meta = BehaviorNotesResponseMeta(fromDictionary: metaData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if behaviorNotes != nil{
			var dictionaryElements = [[String:Any]]()
			for behaviorNotesElement in behaviorNotes {
				dictionaryElements.append(behaviorNotesElement.toDictionary())
			}
			dictionary["behavior_notes"] = dictionaryElements
		}
		if meta != nil{
			dictionary["meta"] = meta.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         behaviorNotes = aDecoder.decodeObject(forKey :"behavior_notes") as? [BehaviorNote]
         meta = aDecoder.decodeObject(forKey: "meta") as? BehaviorNotesResponseMeta

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if behaviorNotes != nil{
			aCoder.encode(behaviorNotes, forKey: "behavior_notes")
		}
		if meta != nil{
			aCoder.encode(meta, forKey: "meta")
		}

	}

}
