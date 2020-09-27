//
//  ViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/22/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SkyFloatingLabelTextField

class SchoolCodeViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    let userDefault = UserDefaults.standard
    
    //MARK: - Outlets
    @IBOutlet weak var schoolCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet var errorLabel: UILabel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        schoolCodeTextField.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
//        schoolCodeTextField.underlined()
        schoolCodeTextField.tintColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        schoolCodeTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        schoolCodeTextField.selectedTitleColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        schoolCodeTextField.selectedLineHeight = 1
        schoolCodeTextField.selectedLineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        schoolCodeTextField.placeholder = "Enter the school code".localized
        schoolCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.schoolCodeTextField.becomeFirstResponder()
    
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let floatingField = textField as? SkyFloatingLabelTextField, let text = floatingField.text, text.count > 0 {
            floatingField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            floatingField.selectedLineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
            errorLabel.isHidden = true
        }
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
//        textField.active()
    }
    
    /// reset text field bottom border to grey when not active
    ///
    /// - Parameter textField: textfield user ended editing
    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.inactive()
    }
    
    /// dismisses schoolCode text field if user presses continue
    ///
    /// - Parameter textField: schoolField textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.inactive()
        textField.resignFirstResponder()
        pressContinue()
        return true
    }
    //MARK: - Actions
    
    /// action when user presses continue, shows alert message if the schoolcode field is empty, call the service to get the school base url otherwise
    @IBAction func pressContinue() {
        guard let schoolcode = schoolCodeTextField.text else { return }
              if schoolcode.isEmpty {
                  errorLabel.isHidden = false
                  errorLabel.text = MISSING_SCHOOL_CODE
                  schoolCodeTextField.lineColor = UIColor.red
                  schoolCodeTextField.selectedLineColor = UIColor.red
              } else {
                  getSchoolBy(code: schoolcode.replacingOccurrences(of: " ", with: ""))
              }
    }
    
    /// service call to get the school base url, shows alert messages on errors, otherwise saves base url on keychain and calls moveToLoginVC
    ///
    /// - Parameter code: schoolCode
    private func getSchoolBy(code: String) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: #colorLiteral(red: 0.1568627451, green: 0.7333333333, blue: 0.3058823529, alpha: 1), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters : Parameters = ["code" : code]
        getSchoolurlAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            if isSuccess {
                debugPrint(value as? [String : Any])
                if let result = value as? [String : Any] {
                    let herukoSchoolInfo : HerukoSchoolInfo = HerukoSchoolInfo.init(fromDictionary: result)
                    BASE_URL = herukoSchoolInfo.url!
                    self.userDefault.set(BASE_URL, forKey: "BASE_URL")
                    self.moveToLoginVC(schoolInfo: herukoSchoolInfo)
                } else {
                    self.stopAnimating()
                    showAlert(viewController: self, title: INVALID, message: INVALID_SCHOOL_CODE, completion: nil)
                }
            } else {
                self.stopAnimating()
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    /// navigates to LoginViewController, passes the school name and image url
    ///
    /// - Parameter schoolInfo: school Information come from heruko
    func moveToLoginVC(schoolInfo : HerukoSchoolInfo) {
        let parameters : Parameters = ["code" : schoolInfo.code ?? ""]
        getSchoolInfoAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String: Any] {
                    debugPrint(result)
                    self.schoolCodeTextField.text = ""
                    let schoolInfo: SchoolInfo = SchoolInfo(fromDictionary: result)
                    let loginVC = LoginViewController.instantiate(fromAppStoryboard: .Login)
                    loginVC.title = schoolInfo.name
                    loginVC.imageURL = schoolInfo.avatarUrl
                    loginVC.headerURL = schoolInfo.headerUrl
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
}

