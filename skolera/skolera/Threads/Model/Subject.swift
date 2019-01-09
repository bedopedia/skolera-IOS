//
//    Subject.swift
//
//    Create by Yehia Beram on 27/5/2018
//    Copyright © 2018 TrianglZ LLC. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Subject : NSObject, NSCoding{
    
    var completedLessonsCount : Int!
    var course : Course!
    var courseId : Int!
    var courseName : String!
    var iconName : String!
    var id : Int!
    var lastCompletedLessonName : String!
    var lessonsCount : Int!
    var name : String!
    var stage : Stage!
    var teachers : [Teacher]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        completedLessonsCount = dictionary["completed_lessons_count"] as? Int
        if let courseData = dictionary["course"] as? [String:Any]{
            course = Course(fromDictionary: courseData)
        }
        courseId = dictionary["course_id"] as? Int
        courseName = dictionary["course_name"] as? String
        iconName = dictionary["icon_name"] as? String 
        id = dictionary["id"] as? Int
        lastCompletedLessonName = dictionary["last_completed_lesson_name"] as? String
        lessonsCount = dictionary["lessons_count"] as? Int
        name = dictionary["name"] as? String
        if let stageData = dictionary["stage"] as? [String:Any]{
            stage = Stage(fromDictionary: stageData)
        }
        teachers = [Teacher]()
        if let teachersArray = dictionary["teachers"] as? [[String:Any]]{
            for dic in teachersArray{
                let value = Teacher(fromDictionary: dic)
                teachers.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if completedLessonsCount != nil{
            dictionary["completed_lessons_count"] = completedLessonsCount
        }
        if course != nil{
            dictionary["course"] = course.toDictionary()
        }
        if courseId != nil{
            dictionary["course_id"] = courseId
        }
        if courseName != nil{
            dictionary["course_name"] = courseName
        }
        if iconName != nil{
            dictionary["icon_name"] = iconName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastCompletedLessonName != nil{
            dictionary["last_completed_lesson_name"] = lastCompletedLessonName
        }
        if lessonsCount != nil{
            dictionary["lessons_count"] = lessonsCount
        }
        if name != nil{
            dictionary["name"] = name
        }
        if stage != nil{
            dictionary["stage"] = stage.toDictionary()
        }
        if teachers != nil{
            var dictionaryElements = [[String:Any]]()
            for teachersElement in teachers {
                dictionaryElements.append(teachersElement.toDictionary())
            }
            dictionary["teachers"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        completedLessonsCount = aDecoder.decodeObject(forKey: "completed_lessons_count") as? Int
        course = aDecoder.decodeObject(forKey: "course") as? Course
        courseId = aDecoder.decodeObject(forKey: "course_id") as? Int
        courseName = aDecoder.decodeObject(forKey: "course_name") as? String
        iconName = aDecoder.decodeObject(forKey: "icon_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        lastCompletedLessonName = aDecoder.decodeObject(forKey: "last_completed_lesson_name") as? String 
        lessonsCount = aDecoder.decodeObject(forKey: "lessons_count") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        stage = aDecoder.decodeObject(forKey: "stage") as? Stage
        teachers = aDecoder.decodeObject(forKey :"teachers") as? [Teacher]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if completedLessonsCount != nil{
            aCoder.encode(completedLessonsCount, forKey: "completed_lessons_count")
        }
        if course != nil{
            aCoder.encode(course, forKey: "course")
        }
        if courseId != nil{
            aCoder.encode(courseId, forKey: "course_id")
        }
        if courseName != nil{
            aCoder.encode(courseName, forKey: "course_name")
        }
        if iconName != nil{
            aCoder.encode(iconName, forKey: "icon_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastCompletedLessonName != nil{
            aCoder.encode(lastCompletedLessonName, forKey: "last_completed_lesson_name")
        }
        if lessonsCount != nil{
            aCoder.encode(lessonsCount, forKey: "lessons_count")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if stage != nil{
            aCoder.encode(stage, forKey: "stage")
        }
        if teachers != nil{
            aCoder.encode(teachers, forKey: "teachers")
        }
        
    }
    
}
