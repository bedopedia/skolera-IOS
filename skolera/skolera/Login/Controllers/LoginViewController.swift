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
import SkyFloatingLabelTextField

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    //MARKL - Variables
    var imageURL: String?
    var showPassword = false
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var schoolImageView: UIImageView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var emailErrorLabel: UILabel!
    
    //MARK: - Life Cycle
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        //        self.emailTextField.underlined()
        self.emailTextField.clearButtonMode = .never
        //        self.passwordTextField.underlined()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        passwordTextField.rightViewMode = .always
        passwordTextField.addTarget(self, action: #selector(self.passwordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let detailsButton = passwordTextField.setView(.right, image: #imageLiteral(resourceName: "show-password"), width: 50)
        detailsButton.addTarget(self, action: #selector(togglePasswordFieldState(_:)), for: .touchUpInside)
        if let urlString = self.imageURL {
            if let url = URL(string: urlString) {
                self.schoolImageView.kf.setImage(with: url)
            }
        }
        self.schoolImageView.layer.borderWidth = 2
        self.schoolImageView.layer.masksToBounds = false
        self.schoolImageView.layer.borderColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        self.schoolImageView.layer.cornerRadius = 6
        self.schoolImageView.clipsToBounds = true
        setUpFloatingText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func setUpFloatingText() {
        emailTextField.tintColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        emailTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        emailTextField.selectedTitleColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        emailTextField.selectedLineHeight = 1
        emailTextField.selectedLineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        passwordTextField.tintColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        passwordTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        passwordTextField.selectedTitleColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        passwordTextField.selectedLineHeight = 1
        passwordTextField.selectedLineColor = .clear
    }
    
    //MARK: - Keyboard Settings
    
    /// dismiss keyboard when clicked anywhere other than text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        textField.active()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        textField.inactive()
    }
    
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
    
    @objc func passwordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        progressView.trackTintColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        progressView.setProgress( count / 6 , animated: true)
        passwordErrorLabel.isHidden = true
    }
    @objc func emailFieldDidChange(_ textField: UITextField) {
        if let floatingTextField = textField as? SkyFloatingLabelTextField {
            if let text = floatingTextField.text, text.count > 0 {
                floatingTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
                floatingTextField.selectedLineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
                emailErrorLabel.isHidden = true
            }
        }
    }
    enum ErrorCases: String {
        case emptyName = "emptyUname"
        case emptyPassword = "emptyPassword"
        case invalidPassword = "invalid"
    }
    //MARK: - Actions
    
    fileprivate func setErrorView(textField: SkyFloatingLabelTextField, label: UILabel, errorText: String, isPassword: Bool = false) {
        textField.lineColor = UIColor.red
        textField.selectedLineColor = UIColor.red
        label.isHidden = false
        label.text = errorText
        if isPassword {
            progressView.setProgress(0, animated: true)
            progressView.trackTintColor = UIColor.red
        }
    }
    
    func setErrorUi(_ errorCase: ErrorCases) {
        switch errorCase {
        case .emptyName:
            setErrorView(textField: emailTextField, label: emailErrorLabel, errorText: "Email is empty")
        case .emptyPassword:
            setErrorView(textField: passwordTextField, label: passwordErrorLabel, errorText: "Password is empty", isPassword: true)
        case .invalidPassword:
            setErrorView(textField: passwordTextField, label: passwordErrorLabel, errorText: "Password length should be more than 6 characters", isPassword: true)
        }
    }
    
    /// - Parameter sender: login button
    @IBAction func login(_ sender: UIButton) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        if email.isEmpty {
            setErrorUi(.emptyName)
        } else if password.isEmpty {
            setErrorUi(.emptyPassword)
        } else if passwordTextField.text?.count ?? 0 < 6 {
            setErrorUi(.invalidPassword)
        } else {
            authenticate(email: email, password: password)
        }
    }
    @objc func togglePasswordFieldState (_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        //        let buttonTitle = passwordTextField.isSecureTextEntry ? "show" : "hide"
        let buttonImage = passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "show-password") : #imageLiteral(resourceName: "hide-password")
        sender.setImage(buttonImage, for: .normal)
        //        sender.setTitle(buttonTitle, for: .normal)
    }
    
    //    MARK:- Network calls
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
//                        let childProfileVC = TeacherContainerViewController.instantiate(fromAppStoryboard: .HomeScreen)
//                        if !parent.data.userType.elementsEqual("teacher") {
//                            childProfileVC.otherUser = true
//                        }
//                        childProfileVC.actor = parent.data
//                        let nvc = UINavigationController(rootViewController: childProfileVC)
//                        nvc.isNavigationBarHidden = true
//                        nvc.modalPresentationStyle = .fullScreen
//                        self.present(nvc, animated: true, completion: nil)
                        let tabBarVC = TabBarViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        tabBarVC.actor = parent.data
                        if !parent.data.userType.elementsEqual("teacher") {
                            tabBarVC.otherUser = true
                        }
                        let nvc = UINavigationController(rootViewController: tabBarVC)
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

