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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var confirmNewPasswordTextField: UITextField!
    @IBOutlet var confirmNewPasswordErrorLabel: UILabel!
    @IBOutlet var confirmNewPasswordBorder: UIView!
    
    var isFirstLogin = false
    var actableId: Int!
    var themeColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
    var oldPasswordText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.placeholder = "Old password".localized
        newPasswordTextField.placeholder = "New password".localized
        confirmNewPasswordTextField.placeholder = "Confirm new password".localized
        if isFirstLogin {
            titleLabel.text = "Please choose a new password".localized
            oldPasswordTextField.text = oldPasswordText
        } else {
            titleLabel.text = "Change password".localized
            updateButton.backgroundColor = getMainColor()
            themeColor = getMainColor()
        }
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmNewPasswordTextField.delegate = self
        oldPasswordTextField.addTarget(self, action: #selector(self.oldPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        let detailsButton = oldPasswordTextField.setView(.right, image: nil, width: 200)
        detailsButton.addTarget(self, action: #selector(togglePasswordFieldState(_:)), for: .touchUpInside)
        detailsButton.setTitleColor(themeColor, for: .normal)
        detailsButton.setTitle("show".localized, for: .normal)
        let newDetailsButton = newPasswordTextField.setView(.right, image: nil, width: 200)
        newDetailsButton.addTarget(self, action: #selector(toggleNewPasswordFieldState(_:)), for: .touchUpInside)
        newDetailsButton.setTitleColor(themeColor, for: .normal)
        newDetailsButton.setTitle("show".localized, for: .normal)
        newPasswordTextField.addTarget(self, action: #selector(self.newPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmNewPasswordTextField.addTarget(self, action: #selector(self.confirmNewPasswordFieldDidChange), for: UIControl.Event.editingChanged)
        let confirmDetailsButton = confirmNewPasswordTextField.setView(.right, image: nil, width: 200)
        confirmDetailsButton.addTarget(self, action: #selector(togglePasswordConfirmationFieldState(_:)), for: .touchUpInside)
        confirmDetailsButton.setTitleColor(themeColor, for: .normal)
        confirmDetailsButton.setTitle("show".localized, for: .normal)
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
        let buttonTitle = oldPasswordTextField.isSecureTextEntry ?  "show".localized :  "hide".localized
        updateButtonColor(buttonTitle, sender)
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func toggleNewPasswordFieldState (_ sender: UIButton) {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        let buttonTitle = newPasswordTextField.isSecureTextEntry ?  "show".localized :  "hide".localized
        updateButtonColor(buttonTitle, sender)
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    @objc func confirmNewPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            confirmNewPasswordBorder.backgroundColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
            confirmNewPasswordErrorLabel.isHidden = true
        }
    }
    
    
    @objc func togglePasswordConfirmationFieldState (_ sender: UIButton) {
        confirmNewPasswordTextField.isSecureTextEntry = !confirmNewPasswordTextField.isSecureTextEntry
        let buttonTitle = confirmNewPasswordTextField.isSecureTextEntry ?  "show".localized :  "hide".localized
        updateButtonColor(buttonTitle, sender)
        sender.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePassword() {
        if oldPasswordTextField.text!.isEmpty {
            showErrorViewForOld(message: "Password is missing".localized)
        }
        if newPasswordTextField.text!.isEmpty {
            showErrorViewForNew(message: "Password is missing".localized)
        }
        if confirmNewPasswordTextField.text!.isEmpty {
            showErrorViewForNewConfirm(message: "Password is missing".localized)
        }
        if (!oldPasswordTextField.text!.isEmpty && !newPasswordTextField.text!.isEmpty && !confirmNewPasswordTextField.text!.isEmpty) {
            
            if oldPasswordTextField.text?.elementsEqual(newPasswordTextField.text ?? "") ?? false {
                showErrorViewForOld(message: "You cannot choose the same password".localized)
                showErrorViewForNew(message: "You cannot choose the same password".localized)
            } else {
                if !(confirmNewPasswordTextField.text?.elementsEqual(newPasswordTextField.text ?? "") ?? false) {
                    showErrorViewForNew(message: "Password and confirmation do not match".localized)
                    showErrorViewForNewConfirm(message: "Password and confirmation do not match".localized)
                } else {
                    changePassword()
                    
                }
            }
        }
    }
    
    fileprivate func updateButtonColor(_ buttonTitle: String, _ sender: UIButton) {
        if buttonTitle.elementsEqual("hide".localized) {
            sender.setTitleColor(#colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1), for: .normal)
        } else {
            sender.setTitleColor(themeColor, for: .normal)
        }
    }
    func showErrorViewForOld(message: String) {
        oldPasswordErrorLabel.isHidden = false
        oldPasswordErrorLabel.text = message.localized
        oldPasswordBorder.backgroundColor = .red
    }
    
    func showErrorViewForNew(message: String) {
        newPasswordErrorLabel.isHidden = false
        newPasswordErrorLabel.text = message.localized
        newPasswordBorder.backgroundColor = .red
    }
    
    func showErrorViewForNewConfirm(message: String) {
        confirmNewPasswordErrorLabel.isHidden = false
        confirmNewPasswordErrorLabel.text = message.localized
        confirmNewPasswordBorder.backgroundColor = .red
    }
    
    //    must pass the user id if this the the first login
    func changePassword() {
        var parameters: Parameters = [:]
        var id = 0
        if isFirstLogin {
            id = actableId
        } else {
            id = Int(userId())!
        }
        let user: [String: Any] = [ "current_password": oldPasswordTextField.text ?? "",
                                    "id": id,
                                    "password": newPasswordTextField.text ?? "",
                                    "password_confirmation": newPasswordTextField.text ?? "",
                                    "reset_password": true
        ]
        parameters["user"] = user
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        changePasswordAPI(userId: id, parameters: parameters) { (isSuccess, statusCode, response, error) in
            self.stopAnimating()
            if isSuccess {
                self.close()
            } else {
                if statusCode == 401 {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                } else {
                    if let data = response, let serverResponse = String(data: data as! Data, encoding: String.Encoding.utf8) {
                        do {
                            let output = try JSONSerialization.jsonObject(with: serverResponse.data(using: .utf8)!, options: .allowFragments) as? [String:Any]
                            debugPrint ("\(String(describing: output))")
                            if let reasons = output?["reasons"] as? [Any], let reason = reasons.first, let messageString = reason as? String {
                                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!, message: messageString)
                            } else {
                                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                            }
                        }
                        catch {
                            debugPrint (error)
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField{
            confirmNewPasswordTextField.becomeFirstResponder()
        } else {
            updateButton.becomeFirstResponder()
        }
        return true
    }
}

