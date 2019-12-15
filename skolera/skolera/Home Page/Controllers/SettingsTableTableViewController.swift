//
//  SettingsTableTableViewController.swift
//  skolera
//
//  Created by Rana Hossam on 12/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SettingsTableTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            //            change language
            let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
                if Language.language == .arabic {
                    self.showChangeLanguageConfirmation(language: .english)
                } else{
                    self.showChangeLanguageConfirmation(language: .arabic)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            //            change password
        } else if indexPath.row == 3 {
            //            logout
            
            let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
//                if(self.isAnimating) {
//                    self.stopAnimating()
//                }
                self.sendFCM(token: "")
                clearUserDefaults()
                let nvc = UINavigationController()
                let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                nvc.pushViewController(schoolCodeVC, animated: true)
                nvc.modalPresentationStyle = .fullScreen
                self.present(nvc, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
            
        } else if indexPath.row == 4 {
            //        share app
        } else if indexPath.row == 5 {
            //           rate app
        }
    }
    
    //    startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
    //
    //            let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
    //            alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
    //                if Language.language == .arabic {
    //                    self.showChangeLanguageConfirmation(language: .english)
    //                } else{
    //                    self.showChangeLanguageConfirmation(language: .arabic)
    //                }
    //
    //            }))
    //
    //            alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
    //                if(self.isAnimating) {
    //                    self.stopAnimating()
    //                }
    //                self.sendFCM(token: "")
    //                clearUserDefaults()
    //                let nvc = UINavigationController()
    //                let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
    //                nvc.pushViewController(schoolCodeVC, animated: true)
    //                nvc.modalPresentationStyle = .fullScreen
    //                self.present(nvc, animated: true, completion: nil)
    //            }))
    //            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
    //            alert.modalPresentationStyle = .fullScreen
    //            self.present(alert, animated: true, completion: nil)
    func showChangeLanguageConfirmation(language: Language){
        let alert = UIAlertController(title: "Restart Required".localized, message: "This requires restarting the Application.\nAre you sure you want to close the app now?".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { action in
            Language.language = language
            exit(0);
        }))
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: { action in
            // do nothing
        }))
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    
    func sendFCM(token: String) {
        //    startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters: [String: Any] = ["user": ["mobile_device_token": token]]
        sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
            //        self.stopAnimating()
            if isSuccess {
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
}
