//
//  ViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/22/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import KeychainSwift
class SchoolCodeViewController: UIViewController, UITextFieldDelegate {
    //MARK: - Outlets
    @IBOutlet weak var schoolCodeTextField: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolCodeTextField.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        SVProgressHUD.setDefaultMaskType(.clear)
        schoolCodeTextField.underlined()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    /// dismisses schoolCode text field if user presses continue
    ///
    /// - Parameter textField: schoolField textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.inactive()
        textField.resignFirstResponder()
        return true
    }
    //MARK: - Actions
    
    /// action when user presses continue, shows alert message if the schoolcode field is empty, call the service to get the school base url otherwise
    ///
    /// - Parameter sender: continue button
    @IBAction func pressContinue(_ sender: UIButton) {
        guard let schoolcode = schoolCodeTextField.text else { return}
        if schoolcode == "" {
            showAlert(viewController: self, title: MISSING_FIELD , message: MISSING_SCHOOL_CODE, completion: nil)
        } else {
            getSchoolBy(code: schoolcode.replacingOccurrences(of: " ", with: ""))
        }
    }
    
    /// service call to get the school base url, shows alert messages on errors, otherwise saves base url on keychain and calls moveToLoginVC
    ///
    /// - Parameter code: schoolCode
    private func getSchoolBy(code: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = ["code" : code]
        getSchoolurlAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let herukoSchoolInfo : HerukoSchoolInfo = HerukoSchoolInfo.init(fromDictionary: result)
                    BASE_URL = herukoSchoolInfo.url!
                    let keychain = KeychainSwift()
                    keychain.set(BASE_URL, forKey: "BASE_URL")
                    self.moveToLoginVC(schoolInfo: herukoSchoolInfo)
                } else {
                    showAlert(viewController: self, title: INVALID, message: INVALID_SCHOOL_CODE, completion: nil)
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    /// navigates to LoginViewController, passes the school name and image url
    ///
    /// - Parameter schoolInfo: school Information come from heruko
    func moveToLoginVC(schoolInfo : HerukoSchoolInfo) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = ["code" : schoolInfo.code]
        getSchoolInfoAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [String: Any] {
                    self.schoolCodeTextField.text = ""
                    let schoolInfo: SchoolInfo = SchoolInfo(fromDictionary: result)
                    let loginVC = LoginViewController.instantiate(fromAppStoryboard: .Login)
                    loginVC.title = schoolInfo.name
                    loginVC.imageURL = schoolInfo.avatarUrl
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
}

