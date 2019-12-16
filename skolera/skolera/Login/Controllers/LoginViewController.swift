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
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    //MARKL - Variables
    var imageURL: String?
    let userDefault = UserDefaults.standard
    
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
        if email.isEmpty {
            showAlert(viewController: self, title: MISSING_FIELD, message: MISSING_EMAIL, completion: nil)
        } else if password.isEmpty {
            showAlert(viewController: self, title: MISSING_FIELD, message: MISSING_PASSWORD, completion: nil)
        } else {
            authenticate(email: email, password: password)
        }
    }
    /// service call to authenticate user, saves headers needed for future service calls: access-token,client,uid,token type. Navigates to ChildrenListViewController. Alert message is shown for wrong credentials on failure
    ///
    /// - Parameters:
    ///   - email: entered user email
    ///   - password: entered user password
    func authenticate( email: String, password: String) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: #colorLiteral(red: 0.1568627451, green: 0.7333333333, blue: 0.3058823529, alpha: 1), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters : Parameters = [(isValidEmail(testStr: email) ? "email": "username") : email, "password" : password, "mobile": true]
        loginAPI(parameters: parameters) { (isSuccess, statusCode, value, headers, error) in
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let parent : ParentResponse = ParentResponse.init(fromDictionary: result)
                    UIApplication.shared.applicationIconBadgeNumber = parent.data.unseenNotifications
                    self.userDefault.set(email, forKey: "email")
                    self.userDefault.set(password, forKey: "password")
                    self.userDefault.set(headers[ACCESS_TOKEN] as! String, forKey: ACCESS_TOKEN)
                    self.userDefault.set(headers[CLIENT] as! String, forKey: CLIENT)
                    self.userDefault.set(headers[TOKEN_TYPE] as! String, forKey: TOKEN_TYPE)
                    self.userDefault.set(headers[UID] as! String, forKey: UID)
                    self.userDefault.set(String(parent.data.actableId), forKey: ACTABLE_ID)
                    self.userDefault.set(String(parent.data.id), forKey: ID)
                    self.userDefault.set(parent.data.userType, forKey: USER_TYPE)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    debugPrint(parent.data.passwordChanged)
//                    if let passwordChanged = parent.data.passwordChanged, passwordChanged {
//                       self.updateLocale(parent: parent)
//                    } else {
//                        let changePasswordVC = ChangePasswordViewController.instantiate(fromAppStoryboard: .HomeScreen)
//                        changePasswordVC.isFirstLogin = true
//                        self.present(changePasswordVC, animated: true, completion: nil)
//                    }
                    self.stopAnimating()
                    let changePasswordVC = ChangePasswordViewController.instantiate(fromAppStoryboard: .HomeScreen)
                    changePasswordVC.isFirstLogin = true
                    self.present(changePasswordVC, animated: true, completion: nil)
                }
            } else {
                self.stopAnimating()
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!, isLoginError: true)
            }
        }
    }
    
    func getChildren(parentId: Int, childId: Int) {
        getChildrenAPI(parentId: parentId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
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
    
//    check for 406 in failure display the dialogue with a different title
    private func updateLocale(parent: ParentResponse) {
        var locale = ""
        if Locale.current.languageCode!.elementsEqual("ar") {
            locale = "ar"
        } else {
            locale = "en"
        }
        setLocaleAPI(locale) { (isSuccess, statusCode, result, error) in
            if isSuccess {
                if isParent() {
                    self.stopAnimating()
                    let childrenTVC = ChildrenListViewController.instantiate(fromAppStoryboard: .HomeScreen)
                    childrenTVC.userId = parent.data.actableId
                    let nvc = UINavigationController(rootViewController: childrenTVC)
                    nvc.isNavigationBarHidden = true
                    nvc.modalPresentationStyle = .fullScreen
                    self.present(nvc, animated: true, completion: nil)
                } else {
                    if parent.data.userType.elementsEqual("student") {
                        if let _ = parent.data.parentId {
                            self.getChildren(parentId: parent.data.parentId, childId: parent.data.actableId)
                        } else {
                            self.stopAnimating()
                            showNetworkFailureError(viewController: self, statusCode: -1, error: NSError())
                        }
                    } else {
                        self.stopAnimating()
                        let childProfileVC = TeacherContainerViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        if !parent.data.userType.elementsEqual("teacher") {
                            childProfileVC.otherUser = true
                        }
                        childProfileVC.actor = parent.data
                        let nvc = UINavigationController(rootViewController: childProfileVC)
                        nvc.isNavigationBarHidden = true
                        nvc.modalPresentationStyle = .fullScreen
                        self.present(nvc, animated: true, completion: nil)
                    }
                }
            } else {
                self.stopAnimating()
//                if statusCode == 406 {
//                    let changePasswordVC = ChangePasswordViewController.instantiate(fromAppStoryboard: .HomeScreen)
//                    self.present(changePasswordVC, animated: true, completion: nil)
//                } else {
//                    showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
//                        let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
//                        self.navigationController?.pushViewController(schoolCodevc, animated: false)
//                    })
//                }
                showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
                    let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(schoolCodevc, animated: false)
                })
            }
        }
    }
}
