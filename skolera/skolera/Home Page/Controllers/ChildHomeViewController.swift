//
//  ChildHomeViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import KeychainSwift
import Firebase

class ChildHomeViewController: UIViewController {
    
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var threadsView: UIView!
    @IBOutlet weak var announcementsView: UIView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    
    
    //MARK: - Variables
    var child: Child!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let childVc = childViewControllers[0] as? ChildProfileViewController {
            childVc.child = self.child
            childVc.assignmentsText = self.assignmentsText
            childVc.quizzesText = self.quizzesText
            childVc.eventsText = self.eventsText
            childVc.addChildImage()
            childVc.addChildData()
        }
        if isParent() {
            selectFourthTab()
            firstLabel.text = "Announcments".localized
            secondLabel.text = "Messages".localized
            thirdLabel.text = "Notifications".localized
            fourthLabel.text = "Menu".localized
        } else {
            selectFirstTab()
            firstLabel.text = "Home".localized
            secondLabel.text = "Messages".localized
            thirdLabel.text = "Notifications".localized
            fourthLabel.text = "Announcments".localized
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(openSettings))
            self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        }
        let backItem = UIBarButtonItem()
        backItem.title = nil
        
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
    }
    
    @objc func openSettings() {
        let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
            if Language.language == .arabic {
                self.showChangeLanguageConfirmation(language: .english)
            } else{
                self.showChangeLanguageConfirmation(language: .arabic)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
            if(SVProgressHUD.isVisible()) {
                SVProgressHUD.dismiss()
            }
            self.sendFCM(token: "")
            let keychain = KeychainSwift()
            keychain.clear()
            let nvc = UINavigationController()
            let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            nvc.pushViewController(schoolCodeVC, animated: true)
            self.present(nvc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func unSelectAllTabs(){
        navigationItem.rightBarButtonItem = nil
        moreView.isHidden = true
        notificationView.isHidden = true
        threadsView.isHidden = true
        announcementsView.isHidden = true
        if isParent() {
            firstButton.setImage(#imageLiteral(resourceName: "announcmentsNormal"), for: .normal)
            secondButton.setImage(#imageLiteral(resourceName: "messagesNormal"), for: .normal)
            thirdButton.setImage(#imageLiteral(resourceName: "parentNotificationIcon"), for: .normal)
            fourthButton.setImage(#imageLiteral(resourceName: "parentMoreIcon"), for: .normal)
        } else {
            firstButton.setImage(#imageLiteral(resourceName: "studentBookIcon"), for: .normal)
            secondButton.setImage(#imageLiteral(resourceName: "messagesNormal"), for: .normal)
            thirdButton.setImage(#imageLiteral(resourceName: "parentNotificationIcon"), for: .normal)
            fourthButton.setImage(#imageLiteral(resourceName: "announcmentsNormal"), for: .normal)
        }
        
        firstLabel.textColor = .black
        secondLabel.textColor = .black
        thirdLabel.textColor = .black
        fourthLabel.textColor = .black
        
    }
    
    @IBAction func selectFirstTab(){
        unSelectAllTabs()
        if isParent() {
            announcementsView.isHidden = false
            firstLabel.textColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            firstButton.setImage(#imageLiteral(resourceName: "parentActiveAnnouncmentsIcon"), for: .normal)
        } else {
            moreView.isHidden = false
            firstLabel.textColor = #colorLiteral(red: 0.8744605184, green: 0.4455567598, blue: 0.3585537672, alpha: 1)
            firstButton.setImage(#imageLiteral(resourceName: "studentActiveBookIcon"), for: .normal)
        }
        
    }
    
    @IBAction func selectSecondTab(){
        unSelectAllTabs()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMessage))
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        threadsView.isHidden = false
        if isParent() {
            secondLabel.textColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            secondButton.setImage(#imageLiteral(resourceName: "parentActiveMessageIcon"), for: .normal)
        } else {
            secondLabel.textColor = #colorLiteral(red: 0.8744605184, green: 0.4455567598, blue: 0.3585537672, alpha: 1)
            secondButton.setImage(#imageLiteral(resourceName: "studentActiveMessageIcon"), for: .normal)
        }
        
    }
    
    
    @IBAction func selectThirdTab(){
        unSelectAllTabs()
        notificationView.isHidden = false
        if isParent() {
            thirdLabel.textColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            thirdButton.setImage(#imageLiteral(resourceName: "parentActiveNotificationIcon"), for: .normal)
        } else {
            thirdLabel.textColor = #colorLiteral(red: 0.8744605184, green: 0.4455567598, blue: 0.3585537672, alpha: 1)
            thirdButton.setImage(#imageLiteral(resourceName: "studentActiveNotificationIcon"), for: .normal)
            
        }
        
    }
    
    @IBAction func selectFourthTab(){
        unSelectAllTabs()
        fourthLabel.isHidden = false
        if isParent() {
            moreView.isHidden = false
            fourthLabel.textColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            fourthButton.setImage(#imageLiteral(resourceName: "parentActiveMoreIcon"), for: .normal)
        } else {
            announcementsView.isHidden = false
            fourthLabel.textColor = #colorLiteral(red: 0.8744605184, green: 0.4455567598, blue: 0.3585537672, alpha: 1)
            fourthButton.setImage(#imageLiteral(resourceName: "studentActiveAnnouncmentsIcon"), for: .normal)
        }
        
    }
    
    @objc func newMessage() {
        let newMessageVC = NewMessageViewController.instantiate(fromAppStoryboard: .Threads)
        newMessageVC.child = self.child
        self.navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
    func sendFCM(token: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: EDIT_USER(), userId())
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
            case .success(_):
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    //service call to change localization
    func setLocalization() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let locale = Locale.current.languageCode!.elementsEqual("ar") ? "ar" : "en"
        let parameters: Parameters = ["user": ["language": locale]]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: EDIT_USER(), userId())
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
            case .success(_):
                debugPrint("USER_LANGUAGE_CHANGED_SUCCESSFULLY")
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    func showChangeLanguageConfirmation(language: Language){
        let alert = UIAlertController(title: "Restart Required".localized, message: "This requires restarting the Application.\nAre you sure you want to close the app now?".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { action in
            Language.language = language
            exit(0);
        }))
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: { action in
            // do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
