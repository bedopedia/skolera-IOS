//
//  ChangePasswordViewController.swift
//  skolera
//
//  Created by Rana Hossam on 12/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ChangePasswordViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var oldPasswordBorder: UIView!
    @IBOutlet var newPasswordBorder: UIView!
    @IBOutlet var newPasswordErrorLabel: UILabel!
    @IBOutlet var oldPasswordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        updateButton.backgroundColor = getMainColor()
        oldPasswordTextField.addTarget(self, action: #selector(self.oldPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let detailsButton = oldPasswordTextField.setView(.right, image: nil, width: 200)
        detailsButton.addTarget(self, action: #selector(togglePasswordFieldState(_:)), for: .touchUpInside)
        detailsButton.setTitle("show", for: .normal)
        detailsButton.setTitleColor(#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1), for: .normal)
        let newDetailsButton = newPasswordTextField.setView(.right, image: nil, width: 200)
        newDetailsButton.addTarget(self, action: #selector(toggleNewPasswordFieldState(_:)), for: .touchUpInside)
        newDetailsButton.setTitleColor(#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1), for: .normal)
        newDetailsButton.setTitle("show", for: .normal)
        newPasswordTextField.addTarget(self, action: #selector(self.newPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func oldPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            oldPasswordBorder.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
            oldPasswordErrorLabel.isHidden = true
        }
    }
    
    @objc func newPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            newPasswordBorder.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
            newPasswordErrorLabel.isHidden = true
        }
    }

    @objc func togglePasswordFieldState (_ sender: UIButton) {
        oldPasswordTextField.isSecureTextEntry = !oldPasswordTextField.isSecureTextEntry
        let buttonTitle = oldPasswordTextField.isSecureTextEntry ?  "show" :  "hide"
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func toggleNewPasswordFieldState (_ sender: UIButton) {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        let buttonTitle = newPasswordTextField.isSecureTextEntry ?  "show" :  "hide"
        sender.setTitle(buttonTitle, for: .normal)
    }

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePassword() {
        if oldPasswordTextField.text!.isEmpty {
            oldPasswordErrorLabel.isHidden = false
            oldPasswordErrorLabel.text = "Password is missing".localized
            oldPasswordBorder.backgroundColor = .red
        }
        if newPasswordTextField.text!.isEmpty {
            newPasswordErrorLabel.isHidden = false
            newPasswordErrorLabel.text = "Password is missing".localized
            newPasswordBorder.backgroundColor = .red
        }
        if (!oldPasswordTextField.text!.isEmpty && !newPasswordTextField.text!.isEmpty) {
            changePassword()
        }
    }
    
//    must pass the user id if this the the first login
    func changePassword() {
        var parameters: Parameters = [:]
        let user: [String: Any] = [ "current_password": oldPasswordTextField.text ?? "",
                              "id": userId(),
                              "password": newPasswordTextField.text ?? "",
                              "password_confirmation": newPasswordTextField.text ?? "",
                              "reset_password": true
        ]
        parameters["user"] = user
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        changePasswordAPI(userId: Int(userId())!, parameters: parameters) { (isSuccess, statusCode, response, error) in
            self.stopAnimating()
            if isSuccess {
                self.close()
            } else {
                if statusCode == 201 {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                } else {
                    if let result = response as? [String: Any] {
                        if let reasons = result["reasons"] as? [Any], let reason = reasons.first, let messageString = reason as? String {
                            showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!, message: messageString)
                        } else {
                            showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                        }
                    } else {
                       showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                    }
                }
            }
        }
    }

}

extension ChangePasswordViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == oldPasswordTextField {
//            newPasswordTextField.becomeFirstResponder()
//        } else if textField == newPasswordTextField {
//            confirmPasswordTextField.becomeFirstResponder()
//        } else if textField == confirmPasswordTextField {
////            changePassword()
//        }
//        return true
//    }

}
