//
//    Course.swift
//
//    Create by Yehia Beram on 27/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Course : NSObject, NSCoding{
    
    var checklistString : String!
    var code : String!
    var createdAt : String!
    var deletedAt : String!
    var descriptionField : String!
    var hodId : Int!
    var iconName : String!
    var id : Int!
    var levelId : Int!
    var name : String!
    var ownerId : String!
    var passLimit : Int!
    var questionPoolId : String!
    var semesterId : String!
    var showFinalGrade : Bool!
    var totalGrade : Int!
    var updatedAt : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        checklistString = dictionary["checklist_string"] as? String
        code = dictionary["code"] as? String
        createdAt = dictionary["created_at"] as? String
        deletedAt = dictionary["deleted_at"] as? String
        descriptionField = dictionary["description"] as? String
        hodId = dictionary["hod_id"] as? Int
        iconName = dictionary["icon_name"] as? String
        id = dictionary["id"] as? Int
        levelId = dictionary["level_id"] as? Int
        name = dictionary["name"] as? String
        ownerId = dictionary["owner_id"] as? String
        passLimit = dictionary["pass_limit"] as? Int
        questionPoolId = dictionary["question_pool_id"] as? String
        semesterId = dictionary["semester_id"] as? String
        showFinalGrade = dictionary["show_final_grade"] as? Bool
        totalGrade = dictionary["total_grade"] as? Int
        updatedAt = dictionary["updated_at"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if checklistString != nil{
            dictionary["checklist_string"] = checklistString
        }
        if code != nil{
            dictionary["code"] = code
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if deletedAt != nil{
            dictionary["deleted_at"] = deletedAt
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if hodId != nil{
            dictionary["hod_id"] = hodId
        }
        if iconName != nil{
            dictionary["icon_name"] = iconName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if levelId != nil{
            dictionary["level_id"] = levelId
        }
        if name != nil{
            dictionary["name"] = name
        }
        if ownerId != nil{
            dictionary["owner_id"] = ownerId
        }
        if passLimit != nil{
            dictionary["pass_limit"] = passLimit
        }
        if questionPoolId != nil{
            dictionary["question_pool_id"] = questionPoolId
        }
        if semesterId != nil{
            dictionary["semester_id"] = semesterId
        }
        if showFinalGrade != nil{
            dictionary["show_final_grade"] = showFinalGrade
        }
        if totalGrade != nil{
            dictionary["total_grade"] = totalGrade
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        checklistString = aDecoder.decodeObject(forKey: "checklist_string") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        deletedAt = aDecoder.decodeObject(forKey: "deleted_at") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        hodId = aDecoder.decodeObject(forKey: "hod_id") as? Int
        iconName = aDecoder.decodeObject(forKey: "icon_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        levelId = aDecoder.decodeObject(forKey: "level_id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        ownerId = aDecoder.decodeObject(forKey: "owner_id") as? String
        passLimit = aDecoder.decodeObject(forKey: "pass_limit") as? Int
        questionPoolId = aDecoder.decodeObject(forKey: "question_pool_id") as? String
        semesterId = aDecoder.decodeObject(forKey: "semester_id") as? String
        showFinalGrade = aDecoder.decodeObject(forKey: "show_final_grade") as? Bool
        totalGrade = aDecoder.decodeObject(forKey: "total_grade") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if checklistString != nil{
            aCoder.encode(checklistString, forKey: "checklist_string")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if deletedAt != nil{
            aCoder.encode(deletedAt, forKey: "deleted_at")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if hodId != nil{
            aCoder.encode(hodId, forKey: "hod_id")
        }
        if iconName != nil{
            aCoder.encode(iconName, forKey: "icon_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if levelId != nil{
            aCoder.encode(levelId, forKey: "level_id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if ownerId != nil{
            aCoder.encode(ownerId, forKey: "owner_id")
        }
        if passLimit != nil{
            aCoder.encode(passLimit, forKey: "pass_limit")
        }
        if questionPoolId != nil{
            aCoder.encode(questionPoolId, forKey: "question_pool_id")
        }
        if semesterId != nil{
            aCoder.encode(semesterId, forKey: "semester_id")
        }
        if showFinalGrade != nil{
            aCoder.encode(showFinalGrade, forKey: "show_final_grade")
        }
        if totalGrade != nil{
            aCoder.encode(totalGrade, forKey: "total_grade")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        
    }
    
}
