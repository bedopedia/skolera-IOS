//
//  ChildHomeViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import NVActivityIndicatorView

class ChildHomeViewController: UIViewController, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {
    
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
   
    
    @IBOutlet weak var notiificationsDotView: UIView!
    
    //MARK: - Variables
    var child: Actor!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if !isParent() {
//            leftButton.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
//            rightButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        }
//        leftButton.setImage(leftButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
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
//        headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let childNvc = children[0] as? ChildProfileFeaturesNVC, let childVc = childNvc.viewControllers[0] as? ChildProfileViewController{
            childVc.child = self.child
            childVc.assignmentsText = self.assignmentsText
            childVc.quizzesText = self.quizzesText
            childVc.eventsText = self.eventsText
            childVc.addChildImage()
            childVc.addChildData()
        }
        
        for child in children {
            if let childNvc = child as? ContactTeacherNVC {
                childNvc.student = self.child
            }
        }
    }
    
//    @IBAction func leftAction() {
//        if isParent() {
//            self.navigationController?.popViewController(animated: true)
//        } else {
//            openNewMessage()
//        }
//    }
//    
//    @IBAction func rightAction() {
//        if isParent() {
//            openNewMessage()
//        } else {
//            openSettings()
//        }
//    }
    
    func openSettings() {
        let settingsVC = SettingsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    private func openNewMessage() {
        for child in children {
            if let contactTeacherNvc = child as? ContactTeacherNVC {
                let newMessageVC = NewMessageViewController.instantiate(fromAppStoryboard: .Threads)
                newMessageVC.child = self.child
                contactTeacherNvc.pushViewController(newMessageVC, animated: true)
            }
            if let contactTeacher = child as? ContactTeacherViewController {
                contactTeacher.child = self.child
            }
        }
    }
    
    private func unSelectAllTabs(){
        if isParent() {
//            rightButton.isHidden = true
        } else {
//            leftButton.isHidden = true
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
        
        for child in children {
            
            if isParent() {
                if let nvc = child as? AnnouncementsTableViewNVC {
                    if nvc.viewControllers.count == 1 {
//                        self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//                        self.headerView.isHidden = false
                    } else {
//                        self.headerHeightConstraint.constant = 0
//                        self.headerView.isHidden = true
                    }
                }
            } else {
                if let nvc = child as? ChildProfileFeaturesNVC {
                    if nvc.viewControllers.count == 1 {
//                        self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//                        self.headerView.isHidden = false
                    } else {
//                        self.headerHeightConstraint.constant = 0
//                        self.headerView.isHidden = true
                    }
                }
                if let contactTeacher = child as? ContactTeacherNVC {
                    contactTeacher.student = self.child
                }
            }
        }
        
        if !moreView.isHidden {
            for child in children {
                if let childProfileNvc = child as? ChildProfileFeaturesNVC {
                    childProfileNvc.popToRootViewController(animated: false)
                }
            }
        }
        if !announcementsView.isHidden {
            for child in children {
                if let announcementsNvc = child as? AnnouncementsTableViewNVC {
                    announcementsNvc.popToRootViewController(animated: false)
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
        for child in children {
            if let nvc = child as? ContactTeacherNVC {
                if nvc.viewControllers.count == 1 {
//                    self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//                    self.headerView.isHidden = false
                } else {
//                    self.headerHeightConstraint.constant = 0
//                    self.headerView.isHidden = true
                }
            }
        }
        if !threadsView.isHidden {
            for child in children {
                if let threadsNvc = child as? ContactTeacherNVC {
                    threadsNvc.popToRootViewController(animated: false)
                }
            }
        }
        unSelectAllTabs()
        if isParent() {
//            rightButton.isHidden = false
        } else {
//            leftButton.isHidden = false
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
//        self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//        self.headerView.isHidden = false
        unSelectAllTabs()
        notificationView.isHidden = false
        for child in children {
            if let notificationsTableViewController = child as? NotificationsTableViewController {
                notificationsTableViewController.setNotificationsSeen()
            }
        }
        notiificationsDotView.isHidden = true
        if isParent() {
            thirdLabel.textColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            thirdButton.setImage(#imageLiteral(resourceName: "parentActiveNotificationIcon"), for: .normal)
        } else {
            thirdLabel.textColor = #colorLiteral(red: 0.8744605184, green: 0.4455567598, blue: 0.3585537672, alpha: 1)
            thirdButton.setImage(#imageLiteral(resourceName: "studentActiveNotificationIcon"), for: .normal)
        }
    }
    
    @IBAction func selectFourthTab(){
        
        for child in children {
            
            if !isParent() {
                if let nvc = child as? AnnouncementsTableViewNVC {
                    if nvc.viewControllers.count == 1 {
//                        self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//                        self.headerView.isHidden = false
                    } else {
//                        self.headerHeightConstraint.constant = 0
//                        self.headerView.isHidden = true
//                    }
                }
            } else {
                if let nvc = child as? ChildProfileFeaturesNVC {
                    if nvc.viewControllers.count == 1 {
//                        self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//                        self.headerView.isHidden = false
                    } else {
//                        self.headerHeightConstraint.constant = 0
//                        self.headerView.isHidden = true
                    }
                }
            }
        }
            
        if moreView.isHidden == false {
            if isParent() {
                for child in children {
                    if let childProfileNvc = child as? ChildProfileFeaturesNVC {
                        childProfileNvc.popToRootViewController(animated: false)
                    }
                }
            }
        }
        if announcementsView.isHidden == false {
            if !isParent() {
                for child in children {
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
}
    
    //service call to change localization
    
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


