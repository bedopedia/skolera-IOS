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
import SkyFloatingLabelTextField

class ChangePasswordViewController: UIViewController, NVActivityIndicatorViewable, UITextFieldDelegate {
    
//    @IBOutlet var oldPasswordTextField: UITextField!
//    @IBOutlet var newPasswordTextField: UITextField!
//    @IBOutlet var updateButton: UIButton!
//    @IBOutlet var oldPasswordBorder: UIView!
//    @IBOutlet var newPasswordBorder: UIView!
//    @IBOutlet var newPasswordErrorLabel: UILabel!
//    @IBOutlet var oldPasswordErrorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var oldPasswordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var oldPasswordErrorLabel: UILabel!
    
    var isFirstLogin = false
    var actableId: Int!
//    var themeColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFirstLogin {
            titleLabel.text = "Please choose a new password".localized
        } else {
            titleLabel.text = "Change password".localized
//            updateButton.backgroundColor = getMainColor()
//            themeColor = getMainColor()
        }
        oldPasswordTextField.delegate = self
        passwordTextField.delegate = self
        oldPasswordTextField.addTarget(self, action: #selector(self.oldPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(self.newPasswordFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        oldPasswordTextField.placeholder = "Old password".localized
        passwordTextField.placeholder = "New password".localized
        let detailsOldButton = oldPasswordTextField.setView(.right, image: #imageLiteral(resourceName: "show-password"), width: 50)
        detailsOldButton.addTarget(self, action: #selector(toggleOldPasswordFieldState(_:)), for: .touchUpInside)
        let detailsButton = passwordTextField.setView(.right, image: #imageLiteral(resourceName: "show-password"), width: 50)
        detailsButton.addTarget(self, action: #selector(togglePasswordFieldState(_:)), for: .touchUpInside)
        
        oldPasswordTextField.tintColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        oldPasswordTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        oldPasswordTextField.selectedTitleColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        oldPasswordTextField.selectedLineHeight = 1
        oldPasswordTextField.selectedLineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        passwordTextField.tintColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        passwordTextField.lineColor = #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1)
        passwordTextField.selectedTitleColor = #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1)
        passwordTextField.selectedLineHeight = 1
        passwordTextField.selectedLineColor = .clear
    }
    
    @objc func toggleOldPasswordFieldState (_ sender: UIButton) {
        oldPasswordTextField.isSecureTextEntry = !oldPasswordTextField.isSecureTextEntry
        let buttonImage = oldPasswordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "show-password") : #imageLiteral(resourceName: "hide-password")
        sender.setImage(buttonImage, for: .normal)
    }
    
    @objc func togglePasswordFieldState (_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        let buttonImage = passwordTextField.isSecureTextEntry ? #imageLiteral(resourceName: "show-password") : #imageLiteral(resourceName: "hide-password")
        sender.setImage(buttonImage, for: .normal)
    }
    
    @objc func oldPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            oldPasswordErrorLabel.isHidden = true
        }
    }
    
    @objc func newPasswordFieldDidChange(_ textField: UITextField) {
        let count = Float(textField.text?.count ?? 0)
        if count > 0 {
            passwordErrorLabel.isHidden = true
        }
    }
    
    @IBAction func close() {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePassword() {
        if oldPasswordTextField.text!.isEmpty {
            showErrorViewForOld(message: "Password is missing".localized)
        }
        if passwordTextField.text!.isEmpty {
            showErrorViewForNew(message: "Password is missing".localized)
        }
        if (!oldPasswordTextField.text!.isEmpty && !passwordTextField.text!.isEmpty) {
            
            if oldPasswordTextField.text?.elementsEqual(passwordTextField.text ?? "") ?? false {
                showErrorViewForOld(message: "You cannot choose the same password".localized)
                showErrorViewForNew(message: "You cannot choose the same password".localized)
            } else {
                changePassword()
            }
        }
    }
    
    
    func showErrorViewForOld(message: String) {
        oldPasswordErrorLabel.isHidden = false
        oldPasswordErrorLabel.text = message.localized
    }
    
    func showErrorViewForNew(message: String) {
        passwordErrorLabel.isHidden = false
        passwordErrorLabel.text = message.localized
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
                                    "password": passwordTextField.text ?? "",
                                    "password_confirmation": passwordTextField.text ?? "",
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
