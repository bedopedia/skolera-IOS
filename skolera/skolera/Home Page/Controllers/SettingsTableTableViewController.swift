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
    
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var languageLabel: UILabel!
//    @IBOutlet var changeLanguageImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Language.language == .arabic {
            languageLabel.text = "اللغة (العربية)"
//            versionLabel.text = "اصدار 2.9.2"
//            changeLanguageImageView.image = #imageLiteral(resourceName: "backButton")
        } else {
            languageLabel.text = "Language (English)"
//            versionLabel.text = "Version 2.9.2"
            if #available(iOS 13.0, *) {
//                changeLanguageImageView.image = #imageLiteral(resourceName: "chevronRight")
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
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
        } else if indexPath.row == 3 {
            //            change password
            let changePasswordVC = ChangePasswordViewController.instantiate(fromAppStoryboard: .HomeScreen)
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
//            self.present(changePasswordVC, animated: true, completion: nil)
            
        } else if indexPath.row == 4 {
            let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
                if let settingsVC = self.parent as? SettingsViewController, settingsVC.isAnimating {
                    settingsVC.stopAnimating()
                }
                logOut()
                let nvc = UINavigationController()
                let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
                nvc.pushViewController(schoolCodeVC, animated: true)
                nvc.modalPresentationStyle = .fullScreen
                self.present(nvc, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
            
        } else if indexPath.row == 6 {
            let url = URL(string: "https://itunes.apple.com/app/id1346646110")
            var stringToShare = ""
            stringToShare = "https://itunes.apple.com/app/id1346646110"
            //            let imageToShare = UIImage(named: "logo")
            let objectsToShare = [stringToShare, url!] as [Any]
            let activityController = UIActivityViewController(
                activityItems: objectsToShare,
                applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        } else if indexPath.row == 7 {
            if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1346646110") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func showChangeLanguageConfirmation(language: Language){
        let alert = UIAlertController(title: "Restart Required".localized, message: "This requires restarting the Application.\nAre you sure you want to close the app now?".localized, preferredStyle: UIAlertController.Style.alert)
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
}
