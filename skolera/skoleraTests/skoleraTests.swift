//
//  skoleraTests.swift
//  skoleraTests
//
//  Created by Rana Hossam on 9/2/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import XCTest
@testable import skolera
@testable import Alamofire



class skoleraTests: XCTestCase {

    let schoolCode = "edu"
    let chosenLocale = "ar"
    let userEmail = "NP0017"
//    let parentEmail = "pNPS0002"
    let userPassword = "#testpro123S"
    let loginKey = "username" //or email
    let parentId = 416
    let childId = 150
    let parentActableId = 150
    let childActableId = 150
    let teacherActableId = 41
    let timeOutDuration: TimeInterval = 100
 
    func testGetSchoolUrlApi() {
        let promise = expectation(description: "Completion handler invoked")
        let parameters : [String: Any] = ["code" : schoolCode]
        var possibleError: Error!
        var success: Bool!
        skolera.getSchoolurlAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            success = isSuccess
            promise.fulfill()
            if isSuccess {
                if let result = value as? [String: Any] {
                    if let _ = result["code"] as? String {
                        print("code is a string")
                    } else {
                        XCTFail("Error: school code must be string")
                    }
                    if let _ = result["url"] as? String {
                        print("url is a string")
                    } else {
                        XCTFail("Error: school url must be string")
                    }
                }
            } else {
                possibleError = error
                XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertNil(possibleError)
        XCTAssertTrue(success)
//        XCTAssertEqual(statusCode, 200)
    }
    
    func testGetSchoolInfoApi() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        let parameters : [String: Any] = ["code" : schoolCode]
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        getSchoolInfoAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            success = isSuccess
            promise.fulfill()
            if isSuccess {
                if let result = value as? [String: Any] {
                    if let _ = result["avatar_url"] as? String {
                        print("avatar_url is a string")
                    } else {
                        XCTFail("Error: avatar_url must be string")
                    }
                }
            } else {
                XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testSetLocaleAPI() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        let parameters: Parameters = ["user": ["language": chosenLocale]]
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "enRwAelHwn8H_VITSNz4fg"
        headers[TOKEN_TYPE] = "Bearer"
        headers[UID] = "pnps0002@skolera.com"
        headers[CLIENT] = "wsNWS2qtkwJs6jJgiaVrog"
        let url = String(format: EDIT_USER(), "416") //341 for student, 416 parent
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
            case .failure(let error):
                success = false
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testLoginApi() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        var dataValues = ["firstname", "lastname", "id", "avatar_url", "user_type", "name", "actable_id", "actable_type", "unseen_notifications"]
        let parameters : [String: Any] = [loginKey : userEmail, "password" : userPassword, "mobile": true]
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        loginAPI(parameters: parameters) { (isSuccess, statusCode, value, headers, error) in
            success = isSuccess
            if isSuccess {
                promise.fulfill()
                if let result = value as? [String: [String: Any]] {
                    let data = result["data"]
                    if data?.count != 33 {
                        XCTFail("Error: \(error!)")
                    } else {
                        if self.userEmail == "NPS0002" {
                            dataValues.append("parent_id")
                        }
                        for value in dataValues {
                            switch value {
                            case "firstname":
                                if let _ = data?[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: firstname must be string")
                                }
                                
                            case "lastname":
                                if let _ = data?[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: lastname must be string")
                                }
                            case "id":
                                if let _ = data?[value] as? Int {
                                    continue
                                } else {
                                    XCTFail("Error: id must be int")
                                }
                            case "avatar_url":
                                if let _ = data?[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: avatar_url must be string")
                                }
                            case "user_type":
                                if let _ = data?[value] as? String {
                                    continue
                                } else {
                                     XCTFail("Error: user_type must be string")
                                }
                            case "name":
                                if let _ = data?[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: name must be string")
                                }
                            case "actable_id":
                                if let _ = data?[value] as? Int {
                                    continue
                                } else {
                                   XCTFail("Error: actable_id must be int")
                                }
                            case "actable_type":
                                if let _ = data?[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: actable_type must be string")
                                }
                            case "unseen_notifications":
                                if let _ = data?[value] as? Int {
                                    continue
                                } else {
                                    XCTFail("Error: unseen_notifications must be int")
                                }
                            case "parent_id":
                                if let _ = data?[value] as? Int {
                                    continue
                                } else {
                                    XCTFail("Error: parent_id must be int")
                                }
                            default:
                                debugPrint("default")
                            }
                        }
                    }
                }
            } else {
                promise.fulfill()
                XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testGetChildrenApi() { 
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        let parameters : Parameters = ["parent_id" : parentActableId]
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "fJmBEelPcvXbk4Hjlm5kLA"
        headers[TOKEN_TYPE] = "Bearer"
        headers[UID] = "pnps0002@skolera.com"
        headers[CLIENT] = "1V1C3k-VoCmq5RmfwQIQUA"
        let url = String(format: GET_CHILDREN(),"\(parentActableId)")
        let usedParameters = ["actable_id", "attendances", "avatar_url", "firstname", "lastname", "id", "level_name", "name", "today_workload_status"]
        let attendanceParameters = ["comment", "status", "date"]
        let todayWorkLoadParameters = ["attendance_status", "assignments_count", "quizzes_count", "events_count"]
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let result = response.result.value as? [[String: Any]] {
                    if result.isEmpty {
                        XCTFail("Empty Array")
                    }
                    for child in result {
                        for value in usedParameters {
                            switch value {
                            case "firstname":
                                if let _ = child[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: firstname must be string")
                                }
                            case "lastname":
                                if let _ = child[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: lastname must be string")
                                }
                            case "id":
                                if let _ = child[value] as? Int {
                                    continue
                                } else {
                                    XCTFail("Error: id must be int")
                                }
                            case "avatar_url":
                                if let _ = child[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: avatar_url must be string")
                                }
                            case "level_name":
                                if let _ = child[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: level_name must be string")
                                }
                            case "name":
                                if let _ = child[value] as? String {
                                    continue
                                } else {
                                    XCTFail("Error: name must be string")
                                }
                            case "actable_id":
                                if let _ = child[value] as? Int {
                                    continue
                                } else {
                                    XCTFail("Error: actable_id must be int")
                                }
                            case "today_workload_status":
                                if let workLoad = child[value] as? [String: Any] {
                                    for param in todayWorkLoadParameters {
                                        switch param {
                                        case "assignments_count" :
                                            if let _ = workLoad[param] as? Int {
                                                continue
                                            } else {
                                                XCTFail("Error: assignments_count must be int")
                                            }
                                        case "attendance_status" :
                                            if let _ = workLoad[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("Error: attendance_status must be string")
                                            }
                                        case "quizzes_count" :
                                            if let _ = workLoad[param] as? Int {
                                                continue
                                            } else {
                                                XCTFail("Error: quizzes_count must be int")
                                            }
                                        case "events_count" :
                                            if let _ = workLoad[param] as? Int {
                                                continue
                                            } else {
                                                XCTFail("Error: events_count must be int")
                                            }
                                        default:
                                            debugPrint("unlisted")
                                        }
                                    }
                                } else {
                                    XCTFail("Error: invalid response")
                                }
                            case "attendances":
                                if let attendances = child[value] as? [[String: Any]] {
                                    if attendances.isEmpty {
                                        XCTFail("Empty array")
                                    }
                                    for attendance in attendances {
                                        for param in attendanceParameters {
                                            switch param {
                                            case "comment":
                                                if let _ = attendance[param] as? String {
                                                    continue
                                                } else {
                                                    XCTFail("Error: comment must be string")
                                                }
                                            case "status":
                                                if let _ = attendance[param] as? String {
                                                    continue
                                                } else {
                                                    XCTFail("Error: status must be string")
                                                }
                                            case "date":
                                                if let _ = attendance[param] as? Int64 {
                                                    continue
                                                } else {
                                                    XCTFail("Error: date must be Date")
                                                }
                                            default:
                                                debugPrint("unlisted")
                                            }
                                        }
                                    }
                                } else {
                                    XCTFail("Error: invalid response")
                                }
                            default:
                                debugPrint("default")
                            }
                        }
                    }
                }
            case .failure(let error):
                success = false
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testSendFcmTokenApi() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        let parameters: Parameters = ["user": ["mobile_device_token": "token"]]
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "9-UBM7EfYDph11jEbCcbTQ"
        headers[TOKEN_TYPE] = "Bearer"
        headers[UID] = "pnps0002@skolera.com"
        headers[CLIENT] = "GawMGXQa9YtTRRQ9TU076g"
        let url = String(format: EDIT_USER(), "416")
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
            case .failure(let error):
                success = false
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testGetGradesApi() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "ZU9_39pvtY2lioHhC1QCFw"
//        headers[TOKEN_TYPE] = "Bearer"
        headers[UID] = "nps0002@skolera.com"
        headers[CLIENT] = "WNcOpe-9doCWggxzwsyVLA"
        let usedParameters = ["name", "grade", "course_id"]
        let url = String(format: GET_GRADES(), childActableId)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let res = response.result.value as? [String : AnyObject] {
                    if let result = res["courses_grades"] as? [[String: AnyObject]] {
                        if result.isEmpty {
                            XCTFail("empty array")
                        } else {
                            for courseGrade in result {
                                for param in usedParameters {
                                    switch param {
                                    case "name":
                                        if let _ = courseGrade[param] as? String {
                                            continue
                                        } else {
                                            XCTFail("Error: name must be string")
                                        }
                                    case "course_id":
                                        if let _ = courseGrade[param] as? Int {
                                            continue
                                        } else {
                                            XCTFail("Error: course id must be int")
                                        }
                                    case "grade":
                                        if let grade = courseGrade["grade"] as? [String: Any] {
                                            if let _ = grade["letter"] as? String {
                                                continue
                                            } else {
                                                XCTFail("Error: grade letter must be string")
                                            }
                                        } else {
                                            XCTFail("grade object invalid format")
                                        }
                                    default:
                                        debugPrint("default")
                                    }
                                }
                            }
                        }
                        
                    } else {
                        XCTFail("invalid courses grades format")
                    }
            } else {
                XCTFail("invalid response")
            }
            case .failure(let error):
                success = false
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testgetCourseGroupsAPI() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "UwcYggO_GgXjCaU_yBF38Q"
        headers[UID] = "nps0002@skolera.com"
        headers[CLIENT] = "7bJeDuRTSd170FxBiyCBsw"
        let usedParameters = ["course_id", "id", "name"]
        let url = String(format: GET_COURSE_GROUPS(), childId)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let courseGroups = response.result.value as? [[String: Any]] {
                    if courseGroups.isEmpty {
                        XCTFail("Empty array")
                    }
                    for courseGroup in courseGroups {
                        for param in usedParameters {
                            switch param {
                            case "course_id":
                                if let _ = courseGroup[param] as? Int {
                                    continue
                                } else {
                                    XCTFail("course id must be int")
                                }
                            case "id":
                                if let _ = courseGroup[param] as? Int {
                                    continue
                                } else {
                                    XCTFail("id must be int")
                                }
                            case "name":
                                if let _ = courseGroup[param] as? String {
                                    continue
                                } else {
                                    XCTFail("course name must be String")
                                }
                            default:
                                debugPrint("unlisted")
                            }
                        }
                    }
                } else {
                    XCTFail("Invalid response")
                }
            case .failure(let error):
                success = false
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testGetBehaviourNotesCountAPI() {
        let parameters : Parameters = ["student_id" : childActableId,"user_type" : "Parents"]
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "UwcYggO_GgXjCaU_yBF38Q"
        headers[UID] = "nps0002@skolera.com"
        headers[CLIENT] = "7bJeDuRTSd170FxBiyCBsw"
        let usedParams = ["good", "bad", "other"]
        let url = GET_BEHAVIOR_NOTES_COUNT()
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let result = response.result.value as? [String: Any] {
                    for param in usedParams {
                        switch param {
                        case "good":
                            if let _ = result[param] as? Int {
                                continue
                            } else {
                                XCTFail("good count must be int")
                            }
                        case "bad":
                            if let _ = result[param] as? Int {
                                continue
                            } else {
                                XCTFail("bad count must be int")
                            }
                        case "other":
                            if let _ = result[param] as? Int {
                                continue
                            } else {
                                XCTFail("other count must be int")
                            }
                        default:
                            debugPrint("unlisted")
                        }
                    }
                } else {
                    XCTFail("invalid response")
                }
            case .failure(let error):
                success = false
                XCTFail("Error: \(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testGetWeeklyReportsAPI() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "qZHGOhhUwBjj1qPtZ7cbZQ"
        headers[UID] = "nps0002@skolera.com"
        headers[CLIENT] = "zRrNWOJOaUw5TyGnWyCbvw"
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/y"
        formatter.locale = Locale(identifier: "en")
        let url = String(format: GET_WEEKLY_PLANNER(), formatter.string(from: Date()))
        let dailyNotesParameters = ["activities", "class_work", "date", "homework", "title"]
        let weeklyNotesParameters = ["description", "image_url", "title"]
        
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { (response) in
            promise.fulfill()
            switch response.result {
            case .success(_):
                success = true
                if let result = response.result.value as? [String : AnyObject] {
                    if let weaklyPlans = result["weekly_plans"] as? [[String: Any]] {
                        if weaklyPlans.isEmpty {
                            XCTFail("empty weekly plans array ")
                        }
                        for weaklyPlan in weaklyPlans {
                            if let dailyNotes = weaklyPlan["daily_notes"] as? [[String: Any]] {
                                if dailyNotes.isEmpty {
                                    XCTFail("Empty daily notes array")
                                }
                                for dailyNote in dailyNotes {
                                    for param in dailyNotesParameters {
                                        switch param {
                                        case "activities":
                                            if let _ = dailyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("activities must be string")
                                            }
                                        case "class_work":
                                            if let _ = dailyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("class_work must be string")
                                            }
                                        case "date":
                                            if let _ = dailyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("date must be string")
                                            }
                                        case "homework":
                                            if let _ = dailyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("homework must be string")
                                            }
                                        case "title":
                                            if let _ = dailyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("title must be string")
                                            }
                                        default:
                                            debugPrint("unlisted")
                                        }
                                    }
                                }
                                
                            } else {
                                XCTFail("invalid json")
                            }
                            if let weaklyNotes = weaklyPlan["weekly_notes"] as? [[String: Any]] {
                                if weaklyNotes.isEmpty {
                                    XCTFail("Empty weekly notes array")
                                }
                                for weeklyNote in weaklyNotes {
                                    for param in weeklyNotesParameters {
                                        switch param {
                                        case "description":
                                            if let _ = weeklyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("description must be string")
                                            }
                                        case "image_url":
                                            if let _ = weeklyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("image_url must be string")
                                            }
                                        case "title":
                                            if let _ = weeklyNote[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("title must be string")
                                            }
                                        default:
                                            debugPrint("unlisted")
                                        }
                                    }
                                }
                            } else {
                                XCTFail("Invalid response")
                            }
                        }
                    } else {
                        XCTFail("Invalid response")
                    }
                } else {
                    XCTFail("Invalid response")
                }
            case .failure(let error):
                success = false
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    

    func testGetStudentTimeTableAPI() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "-ZtD5rfH7eAZKXjKDqj6QQ"
        headers[UID] = "nps0002@skolera.com"
        headers[CLIENT] = "1AgWbVfZuAJfDEciyuTu0w"
        let usedParameters = ["course_name", "from", "to", "day"]
        let url = String(format: GET_TIME_TABLE(), childActableId)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let result = response.result.value as? [[String: Any]], result.count > 0 {
                    for timeSlot in result {
                        for param in usedParameters {
                            switch param {
                            case "course_name":
                                if let _ = timeSlot[param] as? String {
                                    continue
                                } else{
                                    XCTFail("course name must be string")
                                }
                            case "day":
                                if let _ = timeSlot[param] as? String {
                                    continue
                                } else{
                                    XCTFail("day must be string")
                                }
                            case "from":
                                if let from = timeSlot[param] as? String {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                                    if let _ = dateFormatter.date(from: (from)) {
                                           continue
                                    } else {
                                        XCTFail("from must be a date object")
                                    }
                                   
                                } else{
                                    XCTFail("from must be string")
                                }
                            case "to":
                                if let to = timeSlot[param] as? String {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                                    if let _ = dateFormatter.date(from: (to)) {
                                        continue
                                    } else {
                                        XCTFail("to must be a date object")
                                    }
                                } else{
                                    XCTFail("to must be string")
                                }
                            default:
                                debugPrint("unlisted")
                            }
                        }
                    }
                } else {
                    XCTFail("Empty array")
                }
            case .failure(let error):
                success = false
                XCTFail("Errror:\(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testGetTeacherTimeTableAPI() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        let usedParameters = ["course_name", "from", "to", "day"]
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "0RK_bUuUMq6usi68w50a8Q"
        headers[UID] = "np0017@skolera.com"
        headers[CLIENT] = "U4klzGrRDOTx5I1aG9AlRg"
        let url = String(format: GET_TEACHER_TIME_TABLE(), teacherActableId)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let result = response.result.value as? [[String: Any]], result.count > 0 {
                    for timeSlot in result {
                        for param in usedParameters {
                            switch param {
                            case "course_name":
                                if let _ = timeSlot[param] as? String {
                                    continue
                                } else{
                                    XCTFail("course name must be string")
                                }
                            case "day":
                                if let _ = timeSlot[param] as? String {
                                    continue
                                } else{
                                    XCTFail("day must be string")
                                }
                            case "from":
                                if let from = timeSlot[param] as? String {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                                    if let _ = dateFormatter.date(from: (from)) {
                                        continue
                                    } else {
                                        XCTFail("from must be a date object")
                                    }
                                } else{
                                    XCTFail("from must be string")
                                }
                            case "to":
                                if let to = timeSlot[param] as? String {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "en")
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                                    if let _ = dateFormatter.date(from: (to)) {
                                        continue
                                    } else {
                                        XCTFail("to must be a date object")
                                    }
                                } else{
                                    XCTFail("to must be string")
                                }
                            default:
                                debugPrint("unlisted")
                            }
                        }
                    }
                } else {
                    XCTFail("Empty array")
                }
            case .failure(let error):
                success = false
                XCTFail("Error:\(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }
    
    func testGetNotificationsAPI() {
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        let page = 1
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        var headers = [String : String]()
        headers[ACCESS_TOKEN] = "IdVEchCBEccjdfopf2AJFQ"
        headers[TOKEN_TYPE] = "Bearer"
        headers[UID] = "pnps0002@skolera.com"
        headers[CLIENT] = "zNy4oaugPTIPVYPkE6oNcQ"
        let usedParams = ["meta", "notifications"]
        let metaParams = ["current_page", "total_pages"]
        let notificationParams = ["additional_params", "created_at", "message", "text"]
        let url = String(format: GET_NOTIFCATIONS(),"\(parentId)", page)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            promise.fulfill()
            switch response.result{
            case .success(_):
                success = true
                if let result = response.result.value as? [String: Any] {
                    for usedParam in usedParams {
                        switch usedParam {
                        case "meta":
                            if let meta = result[usedParam] as? [String: Any] {
                                for param in metaParams {
                                    switch param {
                                    case "current_page":
                                        if let _ = meta[param] as? Int {
                                            
                                        } else {
                                            XCTFail("current_page must be int")
                                        }
                                    case "total_pages":
                                        if let _ = meta[param] as? Int {
                                            
                                        } else {
                                            XCTFail("total_pages must be int")
                                        }
                                    default:
                                        debugPrint("unlisted")
                                    }
                                }
                            } else {
                                XCTFail("meta data not availabele")
                            }
                        case  "notifications":
                            if let notifications = result[usedParam] as? [[String: Any]], notifications.count > 0 {
                                for notification in notifications {
                                    for param in notificationParams {
                                        switch param { // ["additional_params", "created_at", "message", "text"]
                                        case "message":
                                            if let _ = notification[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("message must be string")
                                            }
                                        case "text":
                                            if let _ = notification[param] as? String {
                                                continue
                                            } else {
                                                XCTFail("text must be string")
                                            }
                                        case "created_at":
                                            if let at = notification[param] as? String {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.locale = Locale(identifier: "en")
                                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                                                if let _ = dateFormatter.date(from: (at)) {
                                                    continue
                                                } else {
                                                    XCTFail("created_at must be a date object")
                                                }
                                            } else {
                                                XCTFail("created_at must be string")
                                            }
                                        case "additional_params":
                                            if let additionalParams = notification[param] as? [String: Any] {
                                                if let studentNames = additionalParams["studentNames"] as? [String], studentNames.count > 0 {
                                                    continue
                                                } else {
                                                    XCTFail("no student names or names are not strings")
                                                }
                                            } else {
                                                XCTFail("additional params are unavailable ")
                                            }
                                        default:
                                            XCTFail("unavailable param")
                                        }
                                    }
                                }
                            } else {
                                XCTFail("parameter unavailable")
                            }
                        default:
                            XCTFail("parameter unavailable")
                        }
                    }
                    
                }
            case .failure(let error):
                success = false
                XCTFail("Error:\(error)")
            }
        }
        wait(for: [promise], timeout: timeOutDuration)
        XCTAssertTrue(success)
    }

    
//    func testSetNotificationSeenAPI() {
//        let promise = expectation(description: "Completion handler invoked")
//        var success: Bool!
//        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
//        var headers = [String : String]()
//        headers[ACCESS_TOKEN] = "fJmBEelPcvXbk4Hjlm5kLA"
//        headers[TOKEN_TYPE] = "Bearer"
//        headers[UID] = "pnps0002@skolera.com"
//        headers[CLIENT] = "1V1C3k-VoCmq5RmfwQIQUA"
//        let url = String(format: SET_SEEN_NOTIFICATIONS(), parentId)
//        Alamofire.request(url, method: .post, parameters: nil, headers: headers).validate().responseJSON { response in
//            promise.fulfill()
//            switch response.result{
//            case .success(_):
//                
//            case .failure(let error):
//                
//            }
//        }
//        wait(for: [promise], timeout: timeOutDuration)
//        XCTAssertTrue(success)
//    }
    
}
