//
//  ChangePasswordViewController.swift
//  skolera
//
//  Created by Rana Hossam on 12/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
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
        
    }
    
//    @IBAction func changePassword(){
//        oldPasswordTextField.resignFirstResponder()
//        newPasswordTextField.resignFirstResponder()
//        confirmPasswordTextField.resignFirstResponder()
//        if oldPasswordTextField.text!.isEmpty ||
//            newPasswordTextField.text!.isEmpty ||
//            confirmPasswordTextField.text!.isEmpty {
//            showNoticeBar(message: "Enter all fields please".localized)
//        } else if !newPasswordTextField.text!.elementsEqual(confirmPasswordTextField.text!){
//            showNoticeBar(message: "Passwords doesn't match".localized)
//        } else {
//            showLoading()
//            let parameters = [OLD_PASSWORD: oldPasswordTextField.text!, PASSWORD: newPasswordTextField.text!]
//            EndPoints.userUpdate(userId: keychain.get(ID)!, parameters: parameters) { (statusCode, isSuccess, response) in
//                self.hideLoading()
//                if isSuccess {
//                  //  logChangePasswordEvent(userId: self.keychain.get(ID)!)
//                    self.close()
//                } else {
//                    if statusCode == EHttpStatusCode.INVALID_CREDENTIAL.rawValue {
//                        logOut(viewController: self)
//                    } else {
//                        showNoticeBar(message: response)
//                    }
//                }
//            }
//        }
//        
//    }

    
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
