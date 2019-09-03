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
    let chosenLocale = "en"
    let userEmail = "NP0017"
    let parentEmail = "pNPS0002"
    let userPassword = "#testpro123S"
    let loginKey = "username" //or email
    let parentId = 416
    let timeOutDuration: TimeInterval = 5
    
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
        var schoolInfo: SchoolInfo!
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        getSchoolInfoAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            success = isSuccess
            promise.fulfill()
            if isSuccess {
                if let result = value as? [String: Any] {
                    schoolInfo = SchoolInfo(fromDictionary: result)
                }

            } else {
                XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertTrue(success)
        XCTAssertNotNil(schoolInfo, "couldn't parse response")
    }
    
//    setLocaleAPI
    func testSetLocaleAPI() {   // for a specific user setLocalApi gets the user id from the keychain
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        setLocaleAPI(chosenLocale) { (isSuccess, statusCode, error) in
            success = isSuccess
            promise.fulfill()
            if !isSuccess {
                XCTFail("Error: \(error!)")
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertTrue(success)
    }
    
    func testLoginApi() {  //sign in
        let promise = expectation(description: "Completion handler invoked")
        var success: Bool!
        let dataValues = ["firstname", "lastname", "id", "avatar_url", "user_type", "name", "actable_id", "actable_type", "unseen_notifications"]
        let parameters : [String: Any] = [loginKey : parentEmail, "password" : userPassword, "mobile": true]
        skolera.BASE_URL = "https://\(schoolCode).skolera.com"
        loginAPI(parameters: parameters) { (isSuccess, statusCode, value, headers, error) in
            success = isSuccess
            promise.fulfill()
            if isSuccess {
                if let result = value as? [String: [String: Any]] {
                    if result["data"]?.count != 33 {
                        XCTFail("Error: \(error!)")
                    }
                    else {
                        // handle value types
                        // "parent_id" is added to the data values incase the login is for students
                        
                    }
                }
            } else {
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
