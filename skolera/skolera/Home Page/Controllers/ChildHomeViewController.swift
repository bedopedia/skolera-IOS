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

class ChildHomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var moreView: UIView!    //home
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
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var child: Child!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if !isParent() {
            leftButton.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
            rightButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        }
        leftButton.setImage(leftButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
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
            
        }
        let backItem = UIBarButtonItem()
        backItem.title = nil
        
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        
        headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if let childNvc = childViewControllers[0] as? ChildProfileFeaturesNVC, let childVc = childNvc.viewControllers[0] as? ChildProfileViewController{
            //            debugPrint("::::::::::::::::::\(childViewControllers)")
            childVc.child = self.child
            childVc.assignmentsText = self.assignmentsText
            childVc.quizzesText = self.quizzesText
            childVc.eventsText = self.eventsText
            childVc.addChildImage()
            childVc.addChildData()
        }
    }
    
    @IBAction func leftAction() {
        if isParent() {
            self.navigationController?.popViewController(animated: true)
        } else {
            openNewMessage()
        }
    }
    
    @IBAction func rightAction() {
        if isParent() {
            openNewMessage()
        } else {
            openSettings()
        }
    }
    
    private func openSettings() {
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
    
    private func openNewMessage() {
        for child in childViewControllers {
            if let contactTeacherNvc = child as? ContactTeacherNVC {
                let newMessageVC = NewMessageViewController.instantiate(fromAppStoryboard: .Threads)
                newMessageVC.child = self.child
                contactTeacherNvc.pushViewController(newMessageVC, animated: true)
            }
        }
        
    }
    
    private func unSelectAllTabs(){
        if isParent() {
            rightButton.isHidden = true
        } else {
            leftButton.isHidden = true
        }
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
        if moreView.isHidden == false {
            if !isParent() {
                for child in childViewControllers {
                    if let childProfileNvc = child as? ChildProfileFeaturesNVC {
                        childProfileNvc.popToRootViewController(animated: false)
                    }
                }
            }
        }
        if announcementsView.isHidden == false {
            if isParent() {
                if announcementsView.isHidden == false {
                    for child in childViewControllers {
                        if let announcementsNvc = child as? AnnouncementsTableViewNVC {
                            announcementsNvc.popToRootViewController(animated: false)
                        }
                    }
                }
            }
        }
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
        if threadsView.isHidden == false {
            for child in childViewControllers {
                if let threadsNvc = child as? ContactTeacherNVC {
                    threadsNvc.popToRootViewController(animated: false)
                }
            }
        }
        unSelectAllTabs()
        if isParent() {
            rightButton.isHidden = false
        } else {
            leftButton.isHidden = false
        }
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
        if moreView.isHidden == false {
            if isParent() {
                for child in childViewControllers {
                    if let childProfileNvc = child as? ChildProfileFeaturesNVC {
                        childProfileNvc.popToRootViewController(animated: false)
                    }
                }
            }
        }
        if announcementsView.isHidden == false {
            if !isParent() {
                for child in childViewControllers {
                    if let announcementsNvc = child as? AnnouncementsTableViewNVC {
                        announcementsNvc.popToRootViewController(animated: false)
                    }
                }
            }
        }
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
    
    
    
    func sendFCM(token: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    //service call to change localization
    
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
