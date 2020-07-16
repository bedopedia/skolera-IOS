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
import FirebaseInstanceID

class SplashScreenViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    var token = ""
    var openNotifiaction: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUpdate(for: "1346646110")
        navigationController?.isNavigationBarHidden = true
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.token =  result.token
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// acts as Launch Screen till the system either auto login the user if his credentials are saved, or shows the SchoolCode screen to login otherwise
    private func getMainScreen() {
        if userDefault.string(forKey: ACCESS_TOKEN) != nil {
            BASE_URL = userDefault.string(forKey: "BASE_URL") ?? ""
            self.getProfile()
        } else {
            DispatchQueue.main.async {
                let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.pushViewController(schoolCodevc, animated: false)
            }
        }
    }
    
    private func updateLocale(parent: Actor) {
        var locale = ""
        if Locale.current.languageCode!.elementsEqual("ar") {
            locale = "ar"
        } else {
            locale = "en"
        }
        setLocaleAPI(locale, token: self.token, deviceId: UIDevice.current.identifierForVendor!.uuidString) { (isSuccess, statusCode, result, headers, error)  in
            if isSuccess {
                self.userDefault.set(headers[TIMEZONE] as! String, forKey: TIMEZONE)
                debugPrint(NSTimeZone.default)
                if isParent() {
                    let childrenTVC = ChildrenListViewController.instantiate(fromAppStoryboard: .HomeScreen)
                    childrenTVC.kids = parent.children
                    let nvc = UINavigationController(rootViewController: childrenTVC)
                    nvc.isNavigationBarHidden = true
                    nvc.modalPresentationStyle = .fullScreen
                    self.present(nvc, animated: true, completion: nil)
                } else {
                    if parent.userType.elementsEqual("student") {
                        let tabBarVC = TabBarViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        tabBarVC.openNotification = self.openNotifiaction
                        self.openNotifiaction = false
                        //for the child profile VC
                        tabBarVC.actor = parent
                        tabBarVC.assignmentsText = ""
                        tabBarVC.quizzesText = ""
                        tabBarVC.eventsText = ""
                        let nvc = UINavigationController(rootViewController: tabBarVC)
                        nvc.isNavigationBarHidden = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: true, completion: nil)
                    } else {
                        let tabBarVC = TabBarViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        tabBarVC.actor = parent
                        tabBarVC.openNotification = self.openNotifiaction
                        self.openNotifiaction = false
                        if !parent.userType.elementsEqual("teacher") {
                            tabBarVC.otherUser = true
                        }
                        let nvc = UINavigationController(rootViewController: tabBarVC)
                        nvc.isNavigationBarHidden = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: true, completion: nil)
                    }
                }
            } else {
                let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                self.navigationController?.pushViewController(schoolCodevc, animated: false)
            }
        }
    }
    
    
    func getProfile(){
        if let userId =  userDefault.string(forKey: ID) {
            getProfileAPI(id: Int(userId) ?? 0) { (isSuccess, statusCode, value, error)  in
                if isSuccess {
                    if let result = value as? [String : AnyObject] {
                        let parent : Actor = Actor.init(fromDictionary: result)
                        UIApplication.shared.applicationIconBadgeNumber = parent.unseenNotifications
                        self.updateLocale(parent: parent)
                    }
                } else {
                    let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(schoolCodevc, animated: false)
                }
            }
        } else {
            let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            self.navigationController?.pushViewController(schoolCodevc, animated: false)
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

