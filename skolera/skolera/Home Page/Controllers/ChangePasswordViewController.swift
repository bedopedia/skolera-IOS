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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        updateButton.backgroundColor = getMainColor()
        oldPasswordTextField.addTarget(self, action: #selector(self.oldPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(self.newPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func oldPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            oldPasswordBorder.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
        }
    }
    
    @objc func newPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            newPasswordBorder.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
        }
    }

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePassword() {
        if oldPasswordTextField.text!.isEmpty {
            oldPasswordBorder.backgroundColor = .red
        }
        if newPasswordTextField.text!.isEmpty {
            newPasswordBorder.backgroundColor = .red
        }
        if (!oldPasswordTextField.text!.isEmpty && !newPasswordTextField.text!.isEmpty) {
            changePassword()
        }
    }
    
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
            if isSuccess {
                self.close()
            } else {
                if statusCode == 201 {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                } else {
                    if let result = response as? [String: Any] {
                        if let reasons = result["reasons"] as? [String] {
                            showNoticeBar(message: reasons.first ?? "")
                        }
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
