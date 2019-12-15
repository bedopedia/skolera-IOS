//
//  App Methods.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import NoticeBar

//alert messages
func showAlert(viewController: UIViewController, title: String, message: String,completion : ((UIAlertAction)->Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: completion)
    alertController.addAction(okAction)
    alertController.modalPresentationStyle = .fullScreen
    viewController.present(alertController, animated: true, completion: nil)
}

func showReauthenticateAlert(viewController: UIViewController) {
    let alertController = UIAlertController(title: "Session ended", message: "Please login again", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: {(ACTION: UIAlertAction) -> Void in
        clearUserDefaults()
        let nvc = UINavigationController()
        let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
        nvc.pushViewController(schoolCodeVC, animated: true)
        nvc.modalPresentationStyle = .fullScreen
        viewController.present(nvc, animated: true, completion: nil)
    })
    alertController.addAction(okAction)
    alertController.modalPresentationStyle = .fullScreen
    viewController.present(alertController, animated: true, completion: {() -> Void in
    })
}

func showNetworkFailureError(viewController: UIViewController, statusCode: Int, error: Error, isLoginError: Bool = false, message: String = "", errorAction: @escaping(() -> ()) = {}) {
    if !message.isEmpty {
        showAlert(viewController: viewController, title: ERROR, message: message, completion: {action in
            errorAction()
        })
    }
    else if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
        showAlert(viewController: viewController, title: ERROR, message: NO_INTERNET, completion: {action in
            errorAction()
        })
    } else if statusCode == 401 || statusCode == 500 {
        if isLoginError {
            showAlert(viewController: viewController, title: INVALID, message: INVALID_USER_INFO, completion: nil)
        } else {
            showReauthenticateAlert(viewController: viewController)
        }
    } else {
        showAlert(viewController: viewController, title: ERROR, message: SOMETHING_WRONG, completion: {action in
            errorAction()
        })
    }
}
//request helpers
func getHeaders() -> [String : String] {
    let userDefault = UserDefaults.standard
    var headers = [String : String]()
    headers[ACCESS_TOKEN] = userDefault.string(forKey: ACCESS_TOKEN) ?? ""
    headers[TOKEN_TYPE] = userDefault.string(forKey: TOKEN_TYPE) ?? ""
    headers[UID] = userDefault.string(forKey: UID) ?? ""
    headers[CLIENT] = userDefault.string(forKey: CLIENT) ?? ""
    return headers
}

func parentId() -> String {
    let userDefault = UserDefaults.standard
    return userDefault.string(forKey: ACTABLE_ID)!
}

func userId() -> String {
    let userDefault = UserDefaults.standard
    return userDefault.string(forKey: ID)!
}

//check if the imageurl is from local server or on amazon aws
func getChildImageURL(urlString imageURL:String) -> URL! {
    if imageURL.contains("amazon"){
        return URL(string: imageURL)
    } else {
        return URL(string: "\(BASE_URL)/uploads/\(imageURL)")
    }
}

func isParent() -> Bool {
    let userDefault = UserDefaults.standard
    return userDefault.string(forKey: USER_TYPE)!.elementsEqual("parent")
}

func getUserType() -> UserType {
    let userDefault = UserDefaults.standard
    return UserType(rawValue: userDefault.string(forKey: USER_TYPE)!) ?? UserType.student
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func image( _ image:UIImage, withSize newSize:CGSize) -> UIImage {
    
    UIGraphicsBeginImageContext(newSize)
    image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!.withRenderingMode(.automatic)
}

func getMainColor() -> UIColor {
    if getUserType() == UserType.student {
        return #colorLiteral(red: 0.9921568627, green: 0.5098039216, blue: 0.4078431373, alpha: 1)
    } else {
        if getUserType() == UserType.parent {
            return #colorLiteral(red: 0.02352941176, green: 0.768627451, blue: 0.8, alpha: 1)
        } else {
            return #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
        }
    }
}

func clearUserDefaults() {
    let userDefault = UserDefaults.standard
    userDefault.removeObject(forKey: ACCESS_TOKEN)
    userDefault.removeObject(forKey: CLIENT)
    userDefault.removeObject(forKey: ACTABLE_ID)
    userDefault.removeObject(forKey: ID)
    userDefault.removeObject(forKey: "email")
    userDefault.removeObject(forKey: "password")
    userDefault.removeObject(forKey: TOKEN_TYPE)
    userDefault.removeObject(forKey: UID)
    userDefault.removeObject(forKey: USER_TYPE)
}

func showNoticeBar(message: String) {
    let config = NoticeBarConfig(title: message, image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: .onTabbar, animationType: NoticeBarAnimationType.bottom )
    let noticeBar = NoticeBar(config: config)
    noticeBar.show(duration: 2) { (finish) in
        
    }
}
