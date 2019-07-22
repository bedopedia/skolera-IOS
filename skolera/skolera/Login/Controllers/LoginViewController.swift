//
//  LoginVC.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/24/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SVProgressHUD
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARKL - Variables
    var imageURL: String?
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var schoolImageView: UIImageView!
    
    //MARK: - Life Cycle
    
    /// calls service to load school image
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.emailTextField.underlined()
        self.passwordTextField.underlined()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
        if let urlString = self.imageURL {
            if let url = URL(string: urlString) {
                
                self.schoolImageView.kf.setImage(with: url)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Keyboard Settings
    
    /// dismiss keyboard when clicked anywhere other than text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// sets text field bottom border to green when active
    ///
    /// - Parameter textField: selected textfield
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.active()
    }
    
    /// reset text field bottom border to grey when not active
    ///
    /// - Parameter textField: textfield user ended editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.inactive()
    }
    /// moves to next text field if user presses continue, if last one keyboard is dismissed
    ///
    /// - Parameter textField: current textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    //MARK: - Actions
    
    /// action when user presses login, shows alert messages if fields are empty, otherwise calls authenticate function with email and password
    ///
    /// - Parameter sender: login button
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        if email == ""
        {
            showAlert(viewController: self, title: MISSING_FIELD, message: MISSING_EMAIL, completion: nil)
        }
        else if password == ""
        {
            showAlert(viewController: self, title: MISSING_FIELD, message: MISSING_PASSWORD, completion: nil)
        }
        else
        {
            authenticate(email: email, password: password)
        }
    }
    
    /// service call to authenticate user, saves headers needed for future service calls: access-token,client,uid,token type. Navigates to ChildrenTableViewController. Alert message is shown for wrong credentials on failure
    ///
    /// - Parameters:
    ///   - email: entered user email
    ///   - password: entered user password
    func authenticate( email: String, password: String)
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = [(isValidEmail(testStr: email) ? "email": "username") : email, "password" : password, "mobile": true]
        let headers : HTTPHeaders? = nil
        debugPrint(SIGN_IN(), parameters)
        Alamofire.request(SIGN_IN(), method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [String : AnyObject]
                {
                    debugPrint(result)
                    let parent : ParentResponse = ParentResponse.init(fromDictionary: result)
                    UIApplication.shared.applicationIconBadgeNumber = parent.data.unseenNotifications
                    if let headers = response.response?.allHeaderFields
                    {
                        let keychain = KeychainSwift()
                        keychain.set(email, forKey: "email")
                        keychain.set(password, forKey: "password")
                        keychain.set(headers[ACCESS_TOKEN] as! String, forKey: ACCESS_TOKEN)
                        keychain.set(headers[CLIENT] as! String, forKey: CLIENT)
                        keychain.set(headers[TOKEN_TYPE] as! String, forKey: TOKEN_TYPE)
                        keychain.set(headers[UID] as! String, forKey: UID)
                        keychain.set(String(parent.data.actableId),forKey: ACTABLE_ID)
                        keychain.set(String(parent.data.id), forKey: ID)
                        keychain.set(parent.data.userType, forKey: USER_TYPE)
                        
//                        if let locale = parent.data.locale, locale  == "ar" {
//                            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//                        }
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
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
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401
                {
                    showAlert(viewController: self, title: INVALID, message: INVALID_USER_INFO, completion: nil)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    func getChildren(parentId: Int, childId: Int)
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = ["parent_id" : parentId]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_CHILDREN(),"\(parentId)")
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    for childJson in result
                    {
                        let child = Child(fromDictionary: childJson)
                        if child.id == childId {
                            let childProfileVC = ChildHomeViewController.instantiate(fromAppStoryboard: .HomeScreen)
                            childProfileVC.child = child
                            childProfileVC.assignmentsText = ""
                            childProfileVC.quizzesText = ""
                            childProfileVC.eventsText = ""
                            self.navigationController?.pushViewController(childProfileVC, animated: true)
                            break
                        }
                        
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                       
                        
                    })
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        })
                }
            }
        }
    }

    
}
