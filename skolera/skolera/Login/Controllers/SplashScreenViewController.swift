//
//  SplashScreenViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/5/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import Firebase
import NRAppUpdate

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        getMainScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func login(_ keychain: KeychainSwift) {
        BASE_URL = keychain.get("BASE_URL")
        var parameters : Parameters = [:]
        if let email = keychain.get("email") {
            if let password = keychain.get("password") {
                parameters = [(isValidEmail(testStr: email) ? "email": "username") : email, "password" : password, "mobile": true]
            }
        } else {
            parameters = [:]
        }
        loginAPI(parameters: parameters) { (isSuccess, statusCode, value, headers, error) in
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let parent : ParentResponse = ParentResponse.init(fromDictionary: result)
                    UIApplication.shared.applicationIconBadgeNumber = parent.data.unseenNotifications
                    let keychain = KeychainSwift()
                    keychain.set(headers[ACCESS_TOKEN] as! String, forKey: ACCESS_TOKEN)
                    keychain.set(headers[CLIENT] as! String, forKey: CLIENT)
                    keychain.set(String(parent.data.actableId),forKey: ACTABLE_ID)
                    keychain.set(String(parent.data.id), forKey: ID)
                    self.updateLocale()
                }
            } else {
                let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.pushViewController(schoolCodevc, animated: false)
            }
        }
    }
    
    /// acts as Launch Screen till the system either auto login the user if his credentials are saved, or shows the SchoolCode screen to login otherwise
    private func getMainScreen() {
        let keychain = KeychainSwift()
        if keychain.get(ACCESS_TOKEN) != nil {
//            login(keychain)
            self.updateLocale()
        } else {
            let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            self.navigationController?.pushViewController(schoolCodevc, animated: false)
        }
    }
    
    
    func getChildren(parentId: Int, childId: Int) {
        getChildrenAPI(parentId: parentId) { (isSuccess, statusCode, value, error) in
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    for childJson in result {
                        let child = Child.init(fromDictionary: childJson)
                        if child.id == childId {
                            let childProfileVC = ChildHomeViewController.instantiate(fromAppStoryboard: .HomeScreen)
                            childProfileVC.child = child
                            childProfileVC.assignmentsText = ""
                            childProfileVC.quizzesText = ""
                            childProfileVC.eventsText = ""
                            let nvc = UINavigationController(rootViewController: childProfileVC)
                            nvc.isNavigationBarHidden = true
                            nvc.modalPresentationStyle = .fullScreen
                            self.present(nvc, animated: true, completion: nil)
                            break
                        }
                    }
                }
            } else {
                showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
                    let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(schoolCodevc, animated: false)
                })
            }
        }
    }
    
    private func updateLocale() {
        var locale = ""
        var parent: ParentResponse!
        if Locale.current.languageCode!.elementsEqual("ar") {
            locale = "ar"
        } else {
            locale = "en"
        }
        debugPrint(userId())
        setLocaleAPI(locale) { (isSuccess, statusCode, value, error) in
            if isSuccess {
                if let result = value as? [String: Any] {
                    parent = ParentResponse.init(fromDictionary: result)
                    if isParent() {
                        let childrenTVC = ChildrenListViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        let nvc = UINavigationController(rootViewController: childrenTVC)
                        nvc.isNavigationBarHidden = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: true, completion: nil)
                    } else {
                        if parent.data.userType.elementsEqual("student") {
                            self.getChildren(parentId: parent.data.parentId, childId: parent.data.actableId)
                        } else {
                            let childProfileVC = TeacherContainerViewController.instantiate(fromAppStoryboard: .HomeScreen)
                            childProfileVC.actor = parent.data
                            if !parent.data.userType.elementsEqual("teacher") {
                                childProfileVC.otherUser = true
                            }
                            let nvc = UINavigationController(rootViewController: childProfileVC)
                            nvc.isNavigationBarHidden = true
                            nvc.modalPresentationStyle = .fullScreen
                            self.present(nvc, animated: true, completion: nil)
                        }
                    }
                }
            } else {
                if statusCode == 401 {
                    let keychain = KeychainSwift()
                    self.login(keychain)
                } else {
                    showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
                        let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                        self.navigationController?.pushViewController(schoolCodevc, animated: false)
                    })
                }
            }
        }
    }
}
