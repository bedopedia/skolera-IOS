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
                    parameters = [(isValidEmail(testStr: email) ? "email": "username") : email, "password" : password]
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
                        let childProfileVC = ActorViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        childProfileVC.actor = parent.data
                        //                            self.navigationController?.pushViewController(childProfileVC, animated: true)
                        let nvc = UINavigationController(rootViewController: childProfileVC)
                        
                        self.present(nvc, animated: true, completion: nil)
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
}
