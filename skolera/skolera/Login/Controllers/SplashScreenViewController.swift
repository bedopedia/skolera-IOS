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
    
    //MARK:- Methods
    
    /// acts as Launch Screen till the system either auto login the user if his credentials are saved, or shows the SchoolCode screen to login otherwise
    private func getMainScreen()
    {
        let keychain = KeychainSwift()
        if keychain.get(ACCESS_TOKEN) != nil
        {
            BASE_URL = keychain.get("BASE_URL")
            var parameters : Parameters? = nil
            if let email = keychain.get("email")
            {
                if let password = keychain.get("password")
                {
                    parameters = [(isValidEmail(testStr: email) ? "email": "username") : email, "password" : password, "mobile": true]
                }
            }
            else
            {
                parameters = [:]
            }
            
            let headers : HTTPHeaders? = nil
            let url = SIGN_IN()
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                switch response.result{
                    
                case .success(_):
                    if let result = response.result.value as? [String : AnyObject]
                    {
                        let parent : ParentResponse = ParentResponse.init(fromDictionary: result)
                        UIApplication.shared.applicationIconBadgeNumber = parent.data.unseenNotifications
                        
                    
                        if let headers = response.response?.allHeaderFields
                        {
                            let keychain = KeychainSwift()
                            keychain.set(headers[ACCESS_TOKEN] as! String, forKey: ACCESS_TOKEN)
                            keychain.set(headers[CLIENT] as! String, forKey: CLIENT)
                        }
                    
                    if isParent() {
                        let childrenTVC = ChildrenTableViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        let nvc = UINavigationController(rootViewController: childrenTVC)
                        
                        self.present(nvc, animated: true, completion: nil)
                    } else {
                        if parent.data.userType.elementsEqual("student") {
                            self.getChildren(parentId: parent.data.parentId, childId: parent.data.actableId)
                        } else {
                            let childProfileVC = ActorViewController.instantiate(fromAppStoryboard: .HomeScreen)
                            childProfileVC.actor = parent.data
                            //                            self.navigationController?.pushViewController(childProfileVC, animated: true)
                            let nvc = UINavigationController(rootViewController: childProfileVC)
                            
                            self.present(nvc, animated: true, completion: nil)
                        }
                    }
                    
                }
                case .failure(let error):
                    print(error.localizedDescription)
                    let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(schoolCodevc, animated: false)
                    
                    
                }
            }
            
        }
        else
        {
            let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            self.navigationController?.pushViewController(schoolCodevc, animated: false)
        }
    }
    func getChildren(parentId: Int, childId: Int)
    {
        let parameters : Parameters = ["parent_id" : parentId]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_CHILDREN(),"\(parentId)")
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    for childJson in result
                    {
                        let child = Child.init(fromDictionary: childJson)
                        if child.id == childId {
                            let childProfileVC = ChildProfileViewController.instantiate(fromAppStoryboard: .HomeScreen)
                            childProfileVC.child = child
                            childProfileVC.quizzesText = "\(child.todayWorkloadStatus.quizzesCount!) \("Quizzes".localized)".localizedCapitalized
                            childProfileVC.assignmentsText = "\(child.todayWorkloadStatus.assignmentsCount!) \("Assignments".localized)".localizedCapitalized
                            childProfileVC.eventsText = "\(child.todayWorkloadStatus.eventsCount!) \("Events".localized)".localizedCapitalized
                            let nvc = UINavigationController(rootViewController: childProfileVC)
                            
                            self.present(nvc, animated: true, completion: nil)
                            break
                        }
                        
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                        self.navigationController?.pushViewController(schoolCodevc, animated: false)
                        
                    })
                } else if response.response?.statusCode == 401 || response.response?.statusCode == 500 {
                    showReauthenticateAlert(viewController: self)
                } else {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                        self.navigationController?.pushViewController(schoolCodevc, animated: false)
                    })
                }
            }
        }
    }

    
}
