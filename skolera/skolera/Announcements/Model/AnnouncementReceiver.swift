//
//  AnnouncementReceiver.swift
//  skolera
//
//  Created by Yehia Beram on 1/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class AnnouncementReceiver : NSObject, NSCoding{
    
    var id: Int!
    var announcementId: Int!
    var userType: String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        announcementId = dictionary["announcement_id"] as? Int
        userType = dictionary["user_type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if announcementId != nil{
            dictionary["announcement_id"] = announcementId
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
        id = aDecoder.decodeObject(forKey: "id") as? Int
        announcementId = aDecoder.decodeObject(forKey: "announcement_id") as? Int
        userType = aDecoder.decodeObject(forKey: "user_type") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if announcementId != nil{
            aCoder.encode(announcementId, forKey: "announcement_id")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "user_type")
        }
    }
    
}
