//
//    Threads.swift
//
//    Create by Yehia Beram on 20/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Threads : NSObject, NSCoding{
    
    var courseId : Int!
    var courseName : String!
    var id : Int!
    var isRead : Bool!
    var lastAddedDate : String!
    var messages : [Message]!
    var name : String!
    var othersAvatars : [String]!
    var othersNames : String!
    var participants : [Participant]!
    var tag : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        debugPrint(dictionary)
        courseId = dictionary["course_id"] as? Int
        courseName = dictionary["course_name"] as? String
        id = dictionary["id"] as? Int
        isRead = dictionary["is_read"] as? Bool
        lastAddedDate = dictionary["last_added_date"] as? String
        messages = [Message]()
        if let messagesArray = dictionary["messages"] as? [[String:Any]]{
            for dic in messagesArray{
                let value = Message(fromDictionary: dic)
                messages.append(value)
            }
        }
        name = dictionary["name"] as? String
        othersAvatars = dictionary["others_avatars"] as? [String]
        othersNames = dictionary["others_names"] as? String
        participants = [Participant]()
        if let participantsArray = dictionary["participants"] as? [[String:Any]]{
            for dic in participantsArray{
                let value = Participant(fromDictionary: dic)
                participants.append(value)
            }
        }
        tag = dictionary["tag"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if courseId != nil{
            dictionary["course_id"] = courseId
        }
        if courseName != nil{
            dictionary["course_name"] = courseName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isRead != nil{
            dictionary["is_read"] = isRead
        }
        if lastAddedDate != nil{
            dictionary["last_added_date"] = lastAddedDate
        }
        if messages != nil{
            var dictionaryElements = [[String:Any]]()
            for messagesElement in messages {
                dictionaryElements.append(messagesElement.toDictionary())
            }
            dictionary["messages"] = dictionaryElements
        }
        if name != nil{
            dictionary["name"] = name
        }
        if othersAvatars != nil{
            dictionary["others_avatars"] = othersAvatars
        }
        if othersNames != nil{
            dictionary["others_names"] = othersNames
        }
        if participants != nil{
            var dictionaryElements = [[String:Any]]()
            for participantsElement in participants {
                dictionaryElements.append(participantsElement.toDictionary())
            }
            dictionary["participants"] = dictionaryElements
        }
        if tag != nil{
            dictionary["tag"] = tag
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        courseId = aDecoder.decodeObject(forKey: "course_id") as? Int
        courseName = aDecoder.decodeObject(forKey: "course_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        isRead = aDecoder.decodeObject(forKey: "is_read") as? Bool
        lastAddedDate = aDecoder.decodeObject(forKey: "last_added_date") as? String
        messages = aDecoder.decodeObject(forKey :"messages") as? [Message]
        name = aDecoder.decodeObject(forKey: "name") as? String
        othersAvatars = aDecoder.decodeObject(forKey: "others_avatars") as? [String]
        othersNames = aDecoder.decodeObject(forKey: "others_names") as? String
        participants = aDecoder.decodeObject(forKey :"participants") as? [Participant]
        tag = aDecoder.decodeObject(forKey: "tag") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if courseId != nil{
            aCoder.encode(courseId, forKey: "course_id")
        }
        if courseName != nil{
            aCoder.encode(courseName, forKey: "course_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isRead != nil{
            aCoder.encode(isRead, forKey: "is_read")
        }
        if lastAddedDate != nil{
            aCoder.encode(lastAddedDate, forKey: "last_added_date")
        }
        if messages != nil{
            aCoder.encode(messages, forKey: "messages")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if othersAvatars != nil{
            aCoder.encode(othersAvatars, forKey: "others_avatars")
        }
        if othersNames != nil{
            aCoder.encode(othersNames, forKey: "others_names")
        }
        if participants != nil{
            aCoder.encode(participants, forKey: "participants")
        }
        if tag != nil{
            aCoder.encode(tag, forKey: "tag")
        }
        
    }
    
}
