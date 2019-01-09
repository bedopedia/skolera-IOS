//
//	BehaviorNotesResponseReceiver.swift
//
//	Create by Ismail Ahmed on 28/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BehaviorNotesReceiver : NSObject, NSCoding{

	var behaviorNoteId : Int!
	var createdAt : String!
	var deletedAt : AnyObject!
	var id : Int!
	var updatedAt : String!
	var userType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		behaviorNoteId = dictionary["behavior_note_id"] as? Int
		createdAt = dictionary["created_at"] as? String
		deletedAt = dictionary["deleted_at"] as? AnyObject
		id = dictionary["id"] as? Int
		updatedAt = dictionary["updated_at"] as? String
		userType = dictionary["user_type"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if behaviorNoteId != nil{
			dictionary["behavior_note_id"] = behaviorNoteId
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if deletedAt != nil{
			dictionary["deleted_at"] = deletedAt
		}
		if id != nil{
			dictionary["id"] = id
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if userType != nil{
			dictionary["user_type"] = userType
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         behaviorNoteId = aDecoder.decodeObject(forKey: "behavior_note_id") as? Int
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         deletedAt = aDecoder.decodeObject(forKey: "deleted_at") as? AnyObject
         id = aDecoder.decodeObject(forKey: "id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userType = aDecoder.decodeObject(forKey: "user_type") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if behaviorNoteId != nil{
			aCoder.encode(behaviorNoteId, forKey: "behavior_note_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if deletedAt != nil{
			aCoder.encode(deletedAt, forKey: "deleted_at")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userType != nil{
			aCoder.encode(userType, forKey: "user_type")
		}

	}

}
