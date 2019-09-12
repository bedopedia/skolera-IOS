//
//  TeacherContainerViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainSwift
import Alamofire

class TeacherContainerViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var coursesButton: UIButton!
    @IBOutlet weak var coursesLabel: UILabel!
    @IBOutlet weak var coursesContainer: UIView!
    @IBOutlet weak var announcmentsButton: UIButton!
    @IBOutlet weak var announcmentsLabel: UILabel!
    @IBOutlet weak var announcmentContainer: UIView!
    @IBOutlet weak var messagesButton: UIButton!
    @IBOutlet weak var messagesLabel: UILabel!
    @IBOutlet weak var messagesContainer: UIView!
    @IBOutlet weak var notificationsButton: UIButton!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var notificationContainer: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationsDotView: UIView!
    
    
    var actor: Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        selectMenu()
        
//        for child in childViewControllers {
//            if let actorViewController = child as? ActorViewController {
//                actorViewController.actor = self.actor
//            } else if let coursesViewController = child as? TeacherCoursesTableViewController {
//                coursesViewController.actor = self.actor
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for child in childViewControllers {
            if let childNvc = child as? TeacherCoursesTableViewNVC, let coursesViewController = childNvc.viewControllers[0] as? TeacherCoursesTableViewController {
                coursesViewController.actor = self.actor
            } else if let actorNvc = child as? ActorNvc, let actorViewController = actorNvc.viewControllers[0] as? ActorViewController {
                actorViewController.actor = self.actor
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        debugPrint("view will disappear")
    }

    private func unSelectTabs(){
        coursesButton.setImage(#imageLiteral(resourceName: "studentBookIcon"), for: .normal)
        coursesLabel.textColor = .black
        coursesContainer.isHidden  = true
        announcmentsButton.setImage(#imageLiteral(resourceName: "announcmentsNormal"), for: .normal)
        announcmentsLabel.textColor = .black
        announcmentContainer.isHidden = true
        messagesButton.setImage(#imageLiteral(resourceName: "messagesNormal"), for: .normal)
        messagesLabel.textColor = .black
        messagesContainer.isHidden = true
        notificationsButton.setImage(#imageLiteral(resourceName: "notificationNormal"), for: .normal)
        notificationsLabel.textColor = .black
        notificationContainer.isHidden = true
        menuButton.setImage(#imageLiteral(resourceName: "parentMoreIcon"), for: .normal)
        menuLabel.textColor = .black
        menuContainer.isHidden = true
    }
    
    @IBAction func selectCourses() {
        for child in childViewControllers {
            if let nvc = child as? TeacherCoursesTableViewNVC {
                if nvc.viewControllers.count == 1 {
                    self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
                    self.headerView.isHidden = false
                } else {
                    self.headerHeightConstraint.constant = 0
                    self.headerView.isHidden = true
                }
            }
        }
        if coursesContainer.isHidden == false {
            for child in childViewControllers {
                if let teacherCoursesTableViewNvc = child as? TeacherCoursesTableViewNVC {
                    teacherCoursesTableViewNvc.popToRootViewController(animated: false)
                }
            }
        }
        unSelectTabs()
        coursesButton.setImage(#imageLiteral(resourceName: "teacherActiveCourse"), for: .normal)
        coursesLabel.textColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8988257051, alpha: 1)
        coursesContainer.isHidden = false
    }
    
    @IBAction func selectAnnouncements() {
        for child in childViewControllers {
            if let nvc = child as? AnnouncementsTableViewNVC {
                if nvc.viewControllers.count == 1 {
                    self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
                    self.headerView.isHidden = false
                } else {
                    self.headerHeightConstraint.constant = 0
                    self.headerView.isHidden = true
                }
            }
        }
        if announcmentContainer.isHidden == false {
            for child in childViewControllers {
                if let announcementsNvc = child as? AnnouncementsTableViewNVC {
                    announcementsNvc.popToRootViewController(animated: false)
                }
            }
        }
        unSelectTabs()
        announcmentsButton.setImage(#imageLiteral(resourceName: "teacherActiveAnnouncment"), for: .normal)
        announcmentsLabel.textColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8988257051, alpha: 1)
        announcmentContainer.isHidden = false
    }
    
    @IBAction func selectMessages() {
        for child in childViewControllers {
            if let nvc = child as? ContactTeacherNVC {
                if nvc.viewControllers.count == 1 {
                    self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
                    self.headerView.isHidden = false
                } else {
                    self.headerHeightConstraint.constant = 0
                    self.headerView.isHidden = true
                }
            }
        }
        unSelectTabs()
        messagesButton.setImage(#imageLiteral(resourceName: "teacherActiveMessage"), for: .normal)
        messagesLabel.textColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8988257051, alpha: 1)
        messagesContainer.isHidden = false
    }
    
    @IBAction func selectNotification() {
        self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
        self.headerView.isHidden = false
        for child in childViewControllers {
            if let notificationsTableViewController = child as? NotificationsTableViewController {
                notificationsTableViewController.setNotificationsSeen()
            }
        }
        notificationsDotView.isHidden = true
        unSelectTabs()
        notificationsButton.setImage(#imageLiteral(resourceName: "teacherActiveNotification"), for: .normal)
        notificationsLabel.textColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8988257051, alpha: 1)
        notificationContainer.isHidden = false
    }
    
    @IBAction func selectMenu() {
        for child in childViewControllers {
            if let nvc = child as? ActorNvc {
                if nvc.viewControllers.count == 1 {
                    self.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
                    self.headerView.isHidden = false
                } else {
                    self.headerHeightConstraint.constant = 0
                    self.headerView.isHidden = true
                }
            }
        }
        if menuContainer.isHidden == false {
            for child in childViewControllers {
                if let actorNvc = child as? ActorNvc {
                    actorNvc.popToRootViewController(animated: false)
                }
            }
        }
        unSelectTabs()
        menuButton.setImage(#imageLiteral(resourceName: "teacherActiveMenu"), for: .normal)
        menuLabel.textColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8988257051, alpha: 1)
        menuContainer.isHidden = false
    }
    
    @IBAction func logout() {
        let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
            if Language.language == .arabic {
                self.showChangeLanguageConfirmation(language: .english)
            } else{
                self.showChangeLanguageConfirmation(language: .arabic)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
            if(SVProgressHUD.isVisible())
            {
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
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
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
}
