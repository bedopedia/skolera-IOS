//
//	ParentData.swift
//
//	Create by Ismail Ahmed on 29/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ParentResponse : NSObject, NSCoding{
	var data : Actor!
	init(fromDictionary dictionary: [String:Any]) {
		if let dataData = dictionary["data"] as? [String:Any]{
			data = Actor(fromDictionary: dataData)
        } else if !dictionary.isEmpty {
            data = Actor(fromDictionary: dictionary)
        }
	}

	func toDictionary() -> [String:Any] {
		var dictionary = [String:Any]()
		if data != nil {
			dictionary["data"] = data.toDictionary()
		}
		return dictionary
	}

    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: "data") as? Actor

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}

	}

}
