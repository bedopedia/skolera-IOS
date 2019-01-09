//
//	BehaviorNotesResponseBehaviorNote.swift
//
//	Create by Ismail Ahmed on 28/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BehaviorNote : NSObject, NSCoding{

	var behaviorNoteCategoryId : Int!
	var category : String!
	var createdAt : String!
	var id : Int!
	var note : String!
	var owner : BehaviorNotesResponseOwner!
	var receivers : [BehaviorNotesResponseReceiver]!
	var student : Child!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		behaviorNoteCategoryId = dictionary["behavior_note_category_id"] as? Int
		category = dictionary["category"] as? String
		createdAt = dictionary["created_at"] as? String
		id = dictionary["id"] as? Int
		note = dictionary["note"] as? String
		if let ownerData = dictionary["owner"] as? [String:Any]{
			owner = BehaviorNotesResponseOwner(fromDictionary: ownerData)
		}
		receivers = [BehaviorNotesResponseReceiver]()
		if let receiversArray = dictionary["receivers"] as? [[String:Any]]{
			for dic in receiversArray{
				let value = BehaviorNotesResponseReceiver(fromDictionary: dic)
				receivers.append(value)
			}
		}
		if let studentData = dictionary["student"] as? [String:Any]{
			student = Child(fromDictionary: studentData)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if behaviorNoteCategoryId != nil{
			dictionary["behavior_note_category_id"] = behaviorNoteCategoryId
		}
		if category != nil{
			dictionary["category"] = category
		}
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if id != nil{
			dictionary["id"] = id
		}
		if note != nil{
			dictionary["note"] = note
		}
		if owner != nil{
			dictionary["owner"] = owner.toDictionary()
		}
		if receivers != nil{
			var dictionaryElements = [[String:Any]]()
			for receiversElement in receivers {
				dictionaryElements.append(receiversElement.toDictionary())
			}
			dictionary["receivers"] = dictionaryElements
		}
		if student != nil{
			dictionary["student"] = student.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         behaviorNoteCategoryId = aDecoder.decodeObject(forKey: "behavior_note_category_id") as? Int
         category = aDecoder.decodeObject(forKey: "category") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         note = aDecoder.decodeObject(forKey: "note") as? String
         owner = aDecoder.decodeObject(forKey: "owner") as? BehaviorNotesResponseOwner
         receivers = aDecoder.decodeObject(forKey :"receivers") as? [BehaviorNotesResponseReceiver]
         student = aDecoder.decodeObject(forKey: "student") as? Child

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if behaviorNoteCategoryId != nil{
			aCoder.encode(behaviorNoteCategoryId, forKey: "behavior_note_category_id")
		}
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if note != nil{
			aCoder.encode(note, forKey: "note")
		}
		if owner != nil{
			aCoder.encode(owner, forKey: "owner")
		}
		if receivers != nil{
			aCoder.encode(receivers, forKey: "receivers")
		}
		if student != nil{
			aCoder.encode(student, forKey: "student")
		}

	}

}
