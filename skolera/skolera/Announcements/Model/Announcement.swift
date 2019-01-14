//
//  Announcement.swift
//  skolera
//
//  Created by Yehia Beram on 1/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation

class Announcement : NSObject, NSCoding{
    
    var id: Int!
    var title: String!
    var body: String!
    var endAt: String!
    var adminId: Int!
    var createdAt: String!
    var announcementReceivers : [AnnouncementReceiver]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        body = dictionary["body"] as? String
        endAt = dictionary["end_at"] as? String
        adminId = dictionary["admin_id"] as? Int
        createdAt = dictionary["created_at"] as? String
        announcementReceivers = [AnnouncementReceiver]()
        if let announcementReceiversArray = dictionary["announcement_receivers"] as? [[String:Any]]{
            for dic in announcementReceiversArray{
                let value = AnnouncementReceiver(fromDictionary: dic)
                announcementReceivers.append(value)
            }
        }
        
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil {
            dictionary["id"] = id
        }
        if title != nil {
            dictionary["title"] = title
        }
        if body != nil {
            dictionary["body"] = body
        }
        if endAt != nil {
            dictionary["end_at"] = endAt
        }
        if adminId != nil {
            dictionary["admin_id"] = adminId
        }
        if createdAt != nil {
            dictionary["created_at"] = createdAt
        }
        if announcementReceivers != nil{
            var dictionaryElements = [[String:Any]]()
            for announcementReciverElement in announcementReceivers {
                dictionaryElements.append(announcementReciverElement.toDictionary())
            }
            dictionary["announcement_receivers"] = dictionaryElements
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
        title = aDecoder.decodeObject(forKey: "title") as? String
        body = aDecoder.decodeObject(forKey: "body") as? String
        endAt = aDecoder.decodeObject(forKey: "end_at") as? String
        adminId = aDecoder.decodeObject(forKey :"admin_id") as? Int
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        announcementReceivers = aDecoder.decodeObject(forKey :"announcement_receivers") as? [AnnouncementReceiver]
        
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
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if body != nil{
            aCoder.encode(body, forKey: "body")
        }
        if endAt != nil{
            aCoder.encode(endAt, forKey: "end_at")
        }
        if adminId != nil{
            aCoder.encode(adminId, forKey: "admin_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if announcementReceivers != nil{
            aCoder.encode(announcementReceivers, forKey: "announcement_receivers")
        }
        
    }
}

