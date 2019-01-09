//
//    Grade.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Grade : NSObject, NSCoding{
    
    var letter : String!
    var numeric : Float!
    var percentage : Float!
    var total : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        letter = dictionary["letter"] as? String
        numeric = dictionary["numeric"] as? Float
        percentage = dictionary["percentage"] as? Float
        total = dictionary["total"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if letter != nil{
            dictionary["letter"] = letter
        }
        if numeric != nil{
            dictionary["numeric"] = numeric
        }
        if percentage != nil{
            dictionary["percentage"] = percentage
        }
        if total != nil{
            dictionary["total"] = total
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        letter = aDecoder.decodeObject(forKey: "letter") as? String
        numeric = aDecoder.decodeObject(forKey: "numeric") as? Float
        percentage = aDecoder.decodeObject(forKey: "percentage") as? Float
        total = aDecoder.decodeObject(forKey: "total") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if letter != nil{
            aCoder.encode(letter, forKey: "letter")
        }
        if numeric != nil{
            aCoder.encode(numeric, forKey: "numeric")
        }
        if percentage != nil{
            aCoder.encode(percentage, forKey: "percentage")
        }
        if total != nil{
            aCoder.encode(total, forKey: "total")
        }
        
    }
    
}
