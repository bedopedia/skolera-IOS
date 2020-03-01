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
        setLocaleAPI(locale) { (isSuccess, statusCode, result, error) in
            if isSuccess {
                if isParent() {
                    let childrenTVC = ChildrenListViewController.instantiate(fromAppStoryboard: .HomeScreen)
                    let nvc = UINavigationController(rootViewController: childrenTVC)
                    nvc.isNavigationBarHidden = true
                    nvc.modalPresentationStyle = .fullScreen
                    self.present(nvc, animated: true, completion: nil)
                } else {
                    if parent.userType.elementsEqual("student") {
                        let childProfileVC = ChildHomeViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        childProfileVC.child = parent
                        childProfileVC.assignmentsText = ""
                        childProfileVC.quizzesText = ""
                        childProfileVC.eventsText = ""
                        let nvc = UINavigationController(rootViewController: childProfileVC)
                        nvc.isNavigationBarHidden = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: true, completion: nil)
                    } else {
                        let childProfileVC = TeacherContainerViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        if !parent.userType.elementsEqual("teacher") {
                            childProfileVC.otherUser = true
                        }
                        childProfileVC.actor = parent
                        let nvc = UINavigationController(rootViewController: childProfileVC)
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

