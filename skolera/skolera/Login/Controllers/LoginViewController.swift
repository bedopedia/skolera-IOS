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
import SkyFloatingLabelTextField
import FirebaseInstanceID

class LoginViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    //MARKL - Variables
    var imageURL: String?
    let userDefault = UserDefaults.standard
    var showPassword = false
    
    var token: String = ""
    
    //MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
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
        self.backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        self.emailTextField.clearButtonMode = .never
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        passwordTextField.rightViewMode = .always
        passwordTextField.addTarget(self, action: #selector(self.passwordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(self.emailFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let detailsButton = passwordTextField.setView(.right, image: #imageLiteral(resourceName: "show-password"), width: 50)
        detailsButton.addTarget(self, action: #selector(togglePasswordFieldState(_:)), for: .touchUpInside)
        if let urlString = self.imageURL {
            if let url = URL(string: urlString) {
                self.schoolImageView.kf.setImage(with: url, placeholder: UIImage(named: "splash"))
            }
        } else {
            self.schoolImageView.image = UIImage(named: "splash")
        }
        setUpFloatingText()
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.token =  result.token
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.emailTextField.becomeFirstResponder()
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
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
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
            login()
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

    
    @IBAction func login(){
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
        let buttonImage = passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "show-password") : #imageLiteral(resourceName: "hide-password")
        sender.setImage(buttonImage, for: .normal)
    }
    
    //    MARK:- Network calls
    /// service call to authenticate user, saves headers needed for future service calls: access-token,client,uid,token type. Navigates to ChildrenListViewController. Alert message is shown for wrong credentials on failure
    ///
    /// - Parameters:
    ///   - email: entered user email
    ///   - password: entered user password
    func authenticate( email: String, password: String) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: #colorLiteral(red: 0.1568627451, green: 0.7333333333, blue: 0.3058823529, alpha: 1), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters : Parameters = [(isValidEmail(testStr: email) ? "email": "username") : email, "password" : password, "mobile": true, "mobile_api": true]
        loginAPI(parameters: parameters) { (isSuccess, statusCode, value, headers, error) in
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let parent : Actor = Actor.init(fromDictionary: result)
                    
                    self.userDefault.set(headers[ACCESS_TOKEN] as! String, forKey: ACCESS_TOKEN)
                    self.userDefault.set(headers[CLIENT] as! String, forKey: CLIENT)
                    self.userDefault.set(headers[TOKEN_TYPE] as! String, forKey: TOKEN_TYPE)
                    self.userDefault.set(headers[UID] as! String, forKey: UID)
                    if let passwordChanged = parent.passwordChanged, passwordChanged {
                        UIApplication.shared.applicationIconBadgeNumber = parent.unseenNotifications
                        self.userDefault.set(String(parent.childId), forKey: CHILD_ID)
                        self.userDefault.set(String(parent.id), forKey: ID)
                        self.userDefault.set(parent.userType, forKey: USER_TYPE)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.updateLocale(parent: parent)
                    } else {
                        self.stopAnimating()
                        let changePasswordVC = ChangePasswordViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        changePasswordVC.actableId = parent.childId
                        changePasswordVC.isFirstLogin = true
                        self.present(changePasswordVC, animated: true, completion: nil)
                    }
                }
            } else {
                self.stopAnimating()
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!, isLoginError: true)
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
        setLocaleAPI(locale, token: self.token, deviceId: UIDevice.current.identifierForVendor!.uuidString) { (isSuccess, statusCode, result, error) in
            if isSuccess {
                if isParent() {
                    self.stopAnimating()
                    let childrenTVC = ChildrenListViewController.instantiate(fromAppStoryboard: .HomeScreen)
                    childrenTVC.kids = parent.children
                    let nvc = UINavigationController(rootViewController: childrenTVC)
                    nvc.isNavigationBarHidden = true
                    nvc.modalPresentationStyle = .fullScreen
                    self.present(nvc, animated: true, completion: nil)
                } else {
                    if parent.userType.elementsEqual("student") {
                        let tabBarVC = TabBarViewController.instantiate(fromAppStoryboard: .HomeScreen)
                        //                            for the child profile VC
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
                self.stopAnimating()
                showNetworkFailureError(viewController: self,statusCode: statusCode, error: error!, errorAction: {
                    let schoolCodevc = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                    self.navigationController?.pushViewController(schoolCodevc, animated: false)
                })
            }
        }
    }
}
