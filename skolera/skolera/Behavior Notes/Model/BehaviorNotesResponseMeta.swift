//
//	BehaviorNotesResponseMeta.swift
//
//	Create by Ismail Ahmed on 28/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BehaviorNotesResponseMeta : NSObject, NSCoding{

	var currentPage : Int!
	var nextPage : Int!
	var prevPage : Int!
	var totalCount : Int!
	var totalPages : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		currentPage = dictionary["current_page"] as? Int
		nextPage = dictionary["next_page"] as? Int
		prevPage = dictionary["prev_page"] as? Int
		totalCount = dictionary["total_count"] as? Int
		totalPages = dictionary["total_pages"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if currentPage != nil{
			dictionary["current_page"] = currentPage
		}
		if nextPage != nil{
			dictionary["next_page"] = nextPage
		}
		if prevPage != nil{
			dictionary["prev_page"] = prevPage
		}
		if totalCount != nil{
			dictionary["total_count"] = totalCount
		}
		if totalPages != nil{
			dictionary["total_pages"] = totalPages
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         currentPage = aDecoder.decodeObject(forKey: "current_page") as? Int
         nextPage = aDecoder.decodeObject(forKey: "next_page") as? Int
         prevPage = aDecoder.decodeObject(forKey: "prev_page") as? Int
         totalCount = aDecoder.decodeObject(forKey: "total_count") as? Int
         totalPages = aDecoder.decodeObject(forKey: "total_pages") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if currentPage != nil{
			aCoder.encode(currentPage, forKey: "current_page")
		}
		if nextPage != nil{
			aCoder.encode(nextPage, forKey: "next_page")
		}
		if prevPage != nil{
			aCoder.encode(prevPage, forKey: "prev_page")
		}
		if totalCount != nil{
			aCoder.encode(totalCount, forKey: "total_count")
		}
		if totalPages != nil{
			aCoder.encode(totalPages, forKey: "total_pages")
		}

	}

}
