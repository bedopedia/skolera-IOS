//
//  SplashScreenViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/5/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class SplashScreenViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUpdate(for: "1346646110")
        navigationController?.isNavigationBarHidden = true
        //        getMainScreen()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func login() {
        BASE_URL = userDefault.string(forKey: "BASE_URL") ?? ""
        var parameters : Parameters = [:]
        if let email = userDefault.string(forKey: "email") {
            if let password = userDefault.string(forKey: "password") {
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
                    self.userDefault.set(headers[ACCESS_TOKEN] as! String, forKey: ACCESS_TOKEN)
                    self.userDefault.set(headers[CLIENT] as! String, forKey: CLIENT)
                    self.userDefault.set(String(parent.data.actableId), forKey: ACTABLE_ID)
                    self.userDefault.set(String(parent.data.id), forKey: ID)
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
        if (userDefault.string(forKey: ACCESS_TOKEN) != nil) && (userDefault.string(forKey: ID) != nil) {
            BASE_URL = userDefault.string(forKey: "BASE_URL") ?? ""
            self.updateLocale()
        } else {
            DispatchQueue.main.async {
                let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.pushViewController(schoolCodevc, animated: false)
            }
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
        if Locale.current.languageCode!.elementsEqual("ar") {
            locale = "ar"
        } else {
            locale = "en"
        }
        setLocaleAPI(locale) { (isSuccess, statusCode, value, error) in
            if isSuccess {
                if let result = value as? [String: Any] {
                    let parent = ParentResponse(fromDictionary: result)
                    if isParent() {
                        let childrenTVC = ChildrenListViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        childrenTVC.userId = parent.data.actableId
                        let nvc = UINavigationController(rootViewController: childrenTVC)
                        nvc.isNavigationBarHidden = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: true, completion: nil)
                    } else {
                        if parent.data.userType.elementsEqual("student") {
                            if let parentId = parent.data.parentId {
                                self.getChildren(parentId: parentId, childId: parent.data.actableId)
                            } else {
                                showNetworkFailureError(viewController: self, statusCode: -1, error: NSError())
                            }
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
                    self.login()
                } else {
                    showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
                        let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                        self.navigationController?.pushViewController(schoolCodevc, animated: false)
                    })
                }
            }
        }
    }
    
     func checkUpdate(for appId: String) {
        let itunesUrlString =  "https://itunes.apple.com/jp/lookup/?id=\(appId)"
        let itunesUrl = URL(string: itunesUrlString)
        var request = URLRequest(url: itunesUrl!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                self.navigationController?.isNavigationBarHidden = true
                self.getMainScreen()
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    if let resultArray = parseJSON["results"] as? NSArray {
                        if resultArray.count > 0 {
                            if let result = resultArray.firstObject as? NSDictionary {
                                let version = result["version"] as! String
                                if let bundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                                    if version > bundleVersion {
                                        DispatchQueue.main.async {
                                            self.showUpdateAlert(version: version, appID: appId)
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            self.getMainScreen()
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.getMainScreen()
                                    }
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    self.getMainScreen()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.getMainScreen()
                            }
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.getMainScreen()
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.getMainScreen()
                    }
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    self.getMainScreen()
                }
                
            }
        }
        
        task.resume()
    }
    
     func showUpdateAlert(version: String, appID: String) {
        let itunesUrlString =  "https://itunes.apple.com/app/id\(appID)"
        let itunesUrl = URL(string: itunesUrlString)
        let alert = UIAlertController(title: "Update Available", message: "A new version of app is available. Please update to version now. \(version)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Update now", style: .default) { action in
            if UIApplication.shared.canOpenURL(itunesUrl!) {
                if #available(iOS 10.0, *) {
                    self.navigationController?.isNavigationBarHidden = true
                    self.getMainScreen()
                    UIApplication.shared.open(itunesUrl!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
            
        })
        alert.addAction(UIAlertAction(title: "Not now", style: .default) { action in
            self.navigationController?.isNavigationBarHidden = true
            self.getMainScreen()
            
        })
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}

