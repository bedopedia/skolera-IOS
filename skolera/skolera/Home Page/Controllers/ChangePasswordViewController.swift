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
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    var userId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    

    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePassword() {
        if oldPasswordTextField.text!.isEmpty ||
            newPasswordTextField.text!.isEmpty ||
            confirmPasswordTextField.text!.isEmpty {
            showNoticeBar(message: "Enter all fields please".localized)
        } else if !newPasswordTextField.text!.elementsEqual(confirmPasswordTextField.text!){
            showNoticeBar(message: "Passwords doesn't match".localized)
        } else {
            changePassword()
        }
    }
    
    func changePassword() {
        let parameters: Parameters = [:]
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        changePasswordAPI(userId: userId, parameters: parameters) { (isSuccess, statusCode, error) in
            if isSuccess {
                self.close()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }


    
}

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
//            changePassword()
        }
        return true
    }

}
