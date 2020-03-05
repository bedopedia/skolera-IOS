//
//	Data.swift
//
//	Create by Ismail Ahmed on 29/1/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Actor : NSObject, NSCoding{

	var actions : [AnyObject]!
	var avatarUrl : String!
	var childId : Int!
	var city : AnyObject!
	var country : AnyObject!
	var dateofbirth : AnyObject!
	var email : String!
	var firstname : String!
	var gender : String!
	var homeAddress : AnyObject!
	var id : Int!
	var isActive : Bool!
	var lastSignInAt : String!
	var lastname : String!
	var locale : String!
	var middlename : AnyObject!
	var name : String!
    var parentId: Int!
	var password : AnyObject!
	var phone : AnyObject!
	var realtimeIp : String!
	var role : Role!
	var schoolName : String!
	var secondaryAddress : AnyObject!
	var secondaryPhone : AnyObject!
	var thumbUrl : String!
	var unseenNotifications : Int!
	var userType : String!
	var username : String!
    var passwordChanged: Bool!
    //child ++
    var attendances : [Attendance]!
    var badges : [AnyObject]!
    var code : String!
    var levelId : Int!
    var levelName : String!
    var sectionName : String!
    var stageName : String!
    var todayWorkloadStatus : TodayWorkloadStatus!
    var children: [Actor]!
    
    
    
    

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		actions = dictionary["actions"] as? [AnyObject]
		avatarUrl = dictionary["avatar_url"] as? String
		childId = dictionary["child_id"] as? Int
		children = [Actor]()
		if let childrenArray = dictionary["children"] as? [[String:Any]]{
			for dic in childrenArray{
				let value = Actor(fromDictionary: dic)
				children.append(value)
			}
		}
		city = dictionary["city"] as AnyObject
		country = dictionary["country"] as AnyObject
		dateofbirth = dictionary["dateofbirth"] as AnyObject
		email = dictionary["email"] as? String
		firstname = dictionary["firstname"] as? String
		gender = dictionary["gender"] as? String
		homeAddress = dictionary["home_address"] as AnyObject
        id = dictionary["id"] as? Int
		isActive = dictionary["is_active"] as? Bool
		lastSignInAt = dictionary["last_sign_in_at"] as? String
		lastname = dictionary["lastname"] as? String
		locale = dictionary["locale"] as? String
		middlename = dictionary["middlename"] as AnyObject
		name = dictionary["name"] as? String
        parentId = dictionary["parent_id"] as? Int
		password = dictionary["password"] as AnyObject
		phone = dictionary["phone"] as AnyObject
		realtimeIp = dictionary["realtime_ip"] as? String
		if let roleData = dictionary["role"] as? [String:Any]{
			role = Role(fromDictionary: roleData)
		}
		schoolName = dictionary["school_name"] as? String
		secondaryAddress = dictionary["secondary_address"] as AnyObject
		secondaryPhone = dictionary["secondary_phone"] as AnyObject
		thumbUrl = dictionary["thumb_url"] as? String
		unseenNotifications = dictionary["unseen_notifications"] as? Int
		userType = dictionary["user_type"] as? String
		username = dictionary["username"] as? String
        passwordChanged = dictionary["password_changed"] as? Bool
        
        attendances = [Attendance]()
        if let attendancesArray = dictionary["attendances"] as? [[String:Any]]{
            for dic in attendancesArray{
                let value = Attendance(fromDictionary: dic)
                attendances.append(value)
            }
        }
        
        badges = dictionary["badges"] as? [AnyObject]
        code = dictionary["code"] as? String
        levelId = dictionary["level_id"] as? Int
        levelName = dictionary["level_name"] as? String
        sectionName = dictionary["section_name"] as? String
        stageName = dictionary["stage_name"] as? String
        if let todayWorkloadStatusData = dictionary["today_workload_status"] as? [String:Any]{
            todayWorkloadStatus = TodayWorkloadStatus(fromDictionary: todayWorkloadStatusData)
        }
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if actions != nil{
			dictionary["actions"] = actions
		}
		if avatarUrl != nil{
			dictionary["avatar_url"] = avatarUrl
		}
		if childId != nil{
			dictionary["child_id"] = childId
		}
		if children != nil{
			var dictionaryElements = [[String:Any]]()
			for childrenElement in children {
				dictionaryElements.append(childrenElement.toDictionary())
			}
			dictionary["children"] = dictionaryElements
		}
		if city != nil{
			dictionary["city"] = city
		}
		if country != nil{
			dictionary["country"] = country
		}
		if dateofbirth != nil{
			dictionary["dateofbirth"] = dateofbirth
		}
		if email != nil{
			dictionary["email"] = email
		}
		if firstname != nil{
			dictionary["firstname"] = firstname
		}
		if gender != nil{
			dictionary["gender"] = gender
		}
		if homeAddress != nil{
			dictionary["home_address"] = homeAddress
		}
		if id != nil{
			dictionary["id"] = id
		}
		if isActive != nil{
			dictionary["is_active"] = isActive
		}
		if lastSignInAt != nil{
			dictionary["last_sign_in_at"] = lastSignInAt
		}
		if lastname != nil{
			dictionary["lastname"] = lastname
		}
		if locale != nil{
			dictionary["locale"] = locale
		}
		if middlename != nil{
			dictionary["middlename"] = middlename
		}
		if name != nil{
			dictionary["name"] = name
		}
        if parentId != nil {
            dictionary["parent_id"] = parentId
        }
		if password != nil{
			dictionary["password"] = password
		}
		if phone != nil{
			dictionary["phone"] = phone
		}
		if realtimeIp != nil{
			dictionary["realtime_ip"] = realtimeIp
		}
		if role != nil{
			dictionary["role"] = role.toDictionary()
		}
		if schoolName != nil{
			dictionary["school_name"] = schoolName
		}
		if secondaryAddress != nil{
			dictionary["secondary_address"] = secondaryAddress
		}
		if secondaryPhone != nil{
			dictionary["secondary_phone"] = secondaryPhone
		}
		if thumbUrl != nil{
			dictionary["thumb_url"] = thumbUrl
		}
		if unseenNotifications != nil{
			dictionary["unseen_notifications"] = unseenNotifications
		}
		if userType != nil{
			dictionary["user_type"] = userType
		}
		if username != nil{
			dictionary["username"] = username
		}
        
        if attendances != nil{
            var dictionaryElements = [[String:Any]]()
            for attendancesElement in attendances {
                dictionaryElements.append(attendancesElement.toDictionary())
            }
            dictionary["attendances"] = dictionaryElements
        }
        
        if badges != nil{
            dictionary["badges"] = badges
        }
        
        if code != nil{
            dictionary["code"] = code
        }
        if levelId != nil{
            dictionary["level_id"] = levelId
        }
        if levelName != nil{
            dictionary["level_name"] = levelName
        }
        if sectionName != nil{
            dictionary["section_name"] = sectionName
        }
        if stageName != nil{
            dictionary["stage_name"] = stageName
        }
        if todayWorkloadStatus != nil{
            dictionary["today_workload_status"] = todayWorkloadStatus.toDictionary()
        }
        
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         actions = aDecoder.decodeObject(forKey: "actions") as? [AnyObject]
         avatarUrl = aDecoder.decodeObject(forKey: "avatar_url") as? String
         childId = aDecoder.decodeObject(forKey: "child_id") as? Int
         //children = aDecoder.decodeObject(forKey :"children") as? [Child]
         city = aDecoder.decodeObject(forKey: "city") as AnyObject
         country = aDecoder.decodeObject(forKey: "country") as AnyObject
         dateofbirth = aDecoder.decodeObject(forKey: "dateofbirth") as AnyObject
         email = aDecoder.decodeObject(forKey: "email") as? String
         firstname = aDecoder.decodeObject(forKey: "firstname") as? String
         gender = aDecoder.decodeObject(forKey: "gender") as? String
         homeAddress = aDecoder.decodeObject(forKey: "home_address") as AnyObject
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isActive = aDecoder.decodeObject(forKey: "is_active") as? Bool
         lastSignInAt = aDecoder.decodeObject(forKey: "last_sign_in_at") as? String
         lastname = aDecoder.decodeObject(forKey: "lastname") as? String
         locale = aDecoder.decodeObject(forKey: "locale") as? String
         middlename = aDecoder.decodeObject(forKey: "middlename") as AnyObject
         name = aDecoder.decodeObject(forKey: "name") as? String
         parentId = aDecoder.decodeObject(forKey: "parent_id") as? Int
         password = aDecoder.decodeObject(forKey: "password") as AnyObject
         phone = aDecoder.decodeObject(forKey: "phone") as AnyObject
         realtimeIp = aDecoder.decodeObject(forKey: "realtime_ip") as? String
         role = aDecoder.decodeObject(forKey: "role") as? Role
         schoolName = aDecoder.decodeObject(forKey: "school_name") as? String
         secondaryAddress = aDecoder.decodeObject(forKey: "secondary_address") as AnyObject
         secondaryPhone = aDecoder.decodeObject(forKey: "secondary_phone") as AnyObject
         thumbUrl = aDecoder.decodeObject(forKey: "thumb_url") as? String
         unseenNotifications = aDecoder.decodeObject(forKey: "unseen_notifications") as? Int
         userType = aDecoder.decodeObject(forKey: "user_type") as? String
         username = aDecoder.decodeObject(forKey: "username") as? String

        attendances = aDecoder.decodeObject(forKey :"attendances") as? [Attendance]
        badges = aDecoder.decodeObject(forKey: "badges") as? [AnyObject]
        code = aDecoder.decodeObject(forKey: "code") as? String
        levelId = aDecoder.decodeObject(forKey: "level_id") as? Int
        levelName = aDecoder.decodeObject(forKey: "level_name") as? String
        sectionName = aDecoder.decodeObject(forKey: "section_name") as? String
        stageName = aDecoder.decodeObject(forKey: "stage_name") as? String
        todayWorkloadStatus = aDecoder.decodeObject(forKey: "today_workload_status") as? TodayWorkloadStatus
                
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if actions != nil{
			aCoder.encode(actions, forKey: "actions")
		}
		if avatarUrl != nil{
			aCoder.encode(avatarUrl, forKey: "avatar_url")
		}
		if childId != nil{
			aCoder.encode(childId, forKey: "child_id")
		}
		if children != nil{
			aCoder.encode(children, forKey: "children")
		}
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if country != nil{
			aCoder.encode(country, forKey: "country")
		}
		if dateofbirth != nil{
			aCoder.encode(dateofbirth, forKey: "dateofbirth")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstname != nil{
			aCoder.encode(firstname, forKey: "firstname")
		}
		if gender != nil{
			aCoder.encode(gender, forKey: "gender")
		}
		if homeAddress != nil{
			aCoder.encode(homeAddress, forKey: "home_address")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if isActive != nil{
			aCoder.encode(isActive, forKey: "is_active")
		}
		if lastSignInAt != nil{
			aCoder.encode(lastSignInAt, forKey: "last_sign_in_at")
		}
		if lastname != nil{
			aCoder.encode(lastname, forKey: "lastname")
		}
		if locale != nil{
			aCoder.encode(locale, forKey: "locale")
		}
		if middlename != nil{
			aCoder.encode(middlename, forKey: "middlename")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
        if name != nil{
            aCoder.encode(parentId, forKey: "parent_id")
        }
		if password != nil{
			aCoder.encode(password, forKey: "password")
		}
		if phone != nil{
			aCoder.encode(phone, forKey: "phone")
		}
		if realtimeIp != nil{
			aCoder.encode(realtimeIp, forKey: "realtime_ip")
		}
		if role != nil{
			aCoder.encode(role, forKey: "role")
		}
		if schoolName != nil{
			aCoder.encode(schoolName, forKey: "school_name")
		}
		if secondaryAddress != nil{
			aCoder.encode(secondaryAddress, forKey: "secondary_address")
		}
		if secondaryPhone != nil{
			aCoder.encode(secondaryPhone, forKey: "secondary_phone")
		}
		if thumbUrl != nil{
			aCoder.encode(thumbUrl, forKey: "thumb_url")
		}
		if unseenNotifications != nil{
			aCoder.encode(unseenNotifications, forKey: "unseen_notifications")
		}
		if userType != nil{
			aCoder.encode(userType, forKey: "user_type")
		}
		if username != nil{
			aCoder.encode(username, forKey: "username")
		}
        
        if attendances != nil{
            aCoder.encode(attendances, forKey: "attendances")
        }
        if badges != nil{
            aCoder.encode(badges, forKey: "badges")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if levelId != nil{
            aCoder.encode(levelId, forKey: "level_id")
        }
        if levelName != nil{
            aCoder.encode(levelName, forKey: "level_name")
        }
        if sectionName != nil{
            aCoder.encode(sectionName, forKey: "section_name")
        }
        if stageName != nil{
            aCoder.encode(stageName, forKey: "stage_name")
        }
        if todayWorkloadStatus != nil{
            aCoder.encode(todayWorkloadStatus, forKey: "today_workload_status")
        }

	}

}
