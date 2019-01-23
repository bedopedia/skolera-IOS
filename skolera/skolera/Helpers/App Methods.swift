//
//  App Methods.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit
import KeychainSwift
//alert messages
func showAlert(viewController: UIViewController, title: String, message: String,completion : ((UIAlertAction)->Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: nil)
}
func showReauthenticateAlert(viewController: UIViewController)
{
    let alertController = UIAlertController(title: "Session ended", message: "Please login again", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: {(ACTION: UIAlertAction) -> Void in
        let keychain = KeychainSwift()
        keychain.clear()
        let nvc = UINavigationController()
        let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
        nvc.pushViewController(schoolCodeVC, animated: true)
        viewController.present(nvc, animated: true, completion: nil)
    })
    alertController.addAction(okAction)
    viewController.present(alertController, animated: true, completion: {() -> Void in
    })
}
//request helpers
func getHeaders() -> [String : String]
{
    let keychain = KeychainSwift()
    var headers = [String : String]()
    headers[ACCESS_TOKEN] = keychain.get(ACCESS_TOKEN)!
    headers[TOKEN_TYPE] = keychain.get(TOKEN_TYPE)!
    headers[UID] = keychain.get(UID)!
    headers[CLIENT] = keychain.get(CLIENT)!
    
    return headers
}
func parentId() -> String
{
    let keychain = KeychainSwift()
    return keychain.get(ACTABLE_ID)!
}
func userId() -> String
{
    let keychain = KeychainSwift()
    return keychain.get(ID)!
}

//check if the imageurl is from local server or on amazon aws
func getChildImageURL(urlString imageURL:String) -> URL!
{
    if imageURL.contains("amazon"){
        return URL(string: imageURL)
    }
    else
    {
        return URL(string: "\(BASE_URL)/uploads/\(imageURL)")
    }
    
}

func isParent() -> Bool {
    let keychain = KeychainSwift()
    return keychain.get(USER_TYPE)!.elementsEqual("parent")
}

func getUserType() -> String {
    let keychain = KeychainSwift()
    return keychain.get(USER_TYPE)!
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
