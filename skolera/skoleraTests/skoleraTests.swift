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
   
//    let schoolCodevc = UIStoryboard(name: "Login", bundle: nil)
//    .instantiateInitialViewController() as? SchoolCodeViewController
    let schoolCode = "edu"
    let chosenLocale = "ar"
    let userEmail = "NP0017"
//    let parentEmail = "pNPS0002"
    let userPassword = "#testpro123S"
    let loginKey = "username" //or email
    let parentId = 416
    let timeOutDuration: TimeInterval = 100
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSchoolUrlApi() {
        let promise = expectation(description: "Completion handler invoked")
        let parameters : [String: Any] = ["code" : schoolCode]
        var possibleError: Error!
        var success: Bool!
        skolera.getSchoolurlAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            success = isSuccess
            promise.fulfill()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let herukoSchoolInfo : HerukoSchoolInfo = HerukoSchoolInfo.init(fromDictionary: result)
                    BASE_URL = herukoSchoolInfo.url!
//                    XCTAssertNotNil(herukoSchoolInfo.url, "no school code available")
                } else {
                    XCTFail("no school code available")
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
    
    func testGetChildrenApi() { //uses getHeaders()
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        getChildrenAPI(parentId: parentId) { (isSuccess, statusCode, value, error) in
            success = isSuccess
            promise.fulfill()
            if !isSuccess {
              XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertTrue(success)
    }
    
    

}
