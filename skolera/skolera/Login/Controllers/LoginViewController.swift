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
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    //MARKL - Variables
    var imageURL: String?
    var showPassword = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    
    //MARK: - Life Cycle
    
    /// calls service to load school image
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.emailTextField.underlined()
        self.emailTextField.clearButtonMode = .never
        self.passwordTextField.underlined()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        passwordTextField.rightViewMode = .always
        passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let detailsButton = passwordTextField.setView(.right, image: nil, width: 50)
        detailsButton.setTitle("show", for: .normal)
        detailsButton.setTitleColor(.black, for: .normal)
        detailsButton.addTarget(self, action: #selector(togglePasswordFieldState(_:)), for: .touchUpInside)
        if let urlString = self.imageURL {
            if let url = URL(string: urlString) {
                self.schoolImageView.kf.setImage(with: url)
            }
        }
        progressView.setProgress(0, animated: true)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        progressView.setProgress( count / 6 , animated: true)
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
    @objc func togglePasswordFieldState (_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        let buttonTitle = passwordTextField.isSecureTextEntry ? "show" : "hide"
        sender.setTitle(buttonTitle, for: .normal)
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
                    debugPrint(keychain.get(USER_TYPE))
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.updateLocale(parent: parent)
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
                        ///////
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
                showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
                    let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(schoolCodevc, animated: false)
                })
            }
        }
    }
}
