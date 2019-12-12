//
//  TabBarViewController.swift
//  skolera
//
//  Created by Rana Hossam on 12/8/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import KeychainSwift

class TabBarViewController: UITabBarController, NVActivityIndicatorViewable {

    var actor: Actor!
    var otherUser: Bool = false
    var child: Child!
    var assignmentsText: String!
    var quizzesText: String!
    var eventsText: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        let userType = getUserType()
        let fontAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10.0), NSAttributedStringKey.backgroundColor: UIColor.black]
        UIBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        tabBar.unselectedItemTintColor = .black
        tabBar.itemPositioning = .centered
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
        let announcementsVC: AnnouncementsTableViewNVC = AnnouncementsTableViewNVC.instantiate(fromAppStoryboard: .Announcements)
        let notificationsVC: NotificationsViewController = NotificationsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        let childProfile: ChildProfileFeaturesNVC = ChildProfileFeaturesNVC.instantiate(fromAppStoryboard: .HomeScreen)
        let teacherProfile: ActorNvc = ActorNvc.instantiate(fromAppStoryboard: .HomeScreen)
        let teacherCourses: TeacherCoursesTableViewNVC = TeacherCoursesTableViewNVC.instantiate(fromAppStoryboard: .HomeScreen)
        let messages: ContactTeacherNVC = ContactTeacherNVC.instantiate(fromAppStoryboard: .Threads)
        switch userType {
        case .teacher:
            viewControllers? = [teacherCourses, announcementsVC, messages, notificationsVC, teacherProfile]
            if let tabItem = tabBar.items?[1] {
                updateTabBarItem(tab: .announcements, tabBarItem: tabItem)
            }
            updateBadgeNumber(arrayIndex: 3)
            self.selectedIndex = 4
            tabBar.tintColor = getMainColor()
        case .student:
            viewControllers? = [childProfile, messages, notificationsVC, announcementsVC]
            if let tabItem = tabBar.items?[3] {
                updateTabBarItem(tab: .announcements, tabBarItem: tabItem)
            }
            updateBadgeNumber(arrayIndex: 2)
            tabBar.tintColor = getMainColor()
        case .parent:
            viewControllers? = [announcementsVC,  messages, notificationsVC, childProfile]
            self.selectedIndex = 3
            tabBar.tintColor = getMainColor()
            updateBadgeNumber(arrayIndex: 2)
        default:
            viewControllers? = [announcementsVC,  messages, notificationsVC]
            tabBar.tintColor = getMainColor()
            updateBadgeNumber(arrayIndex: 2)
        }
        if let tabViewControllers = viewControllers {
            for child in tabViewControllers {
                if let childNvc = child as? TeacherCoursesTableViewNVC, let coursesViewController = childNvc.viewControllers[0] as? TeacherCoursesViewController {
                    coursesViewController.actor = self.actor
                } else if let actorNvc = child as? ActorNvc, let actorViewController = actorNvc.viewControllers[0] as? ActorViewController {
                    actorViewController.actor = self.actor
                }
                else if let contactTeacherNVC = child as? ContactTeacherNVC {
                    contactTeacherNVC.actor = self.actor
                }
                else if let announcementsNVC = child as? AnnouncementsTableViewNVC {
                    announcementsNVC.nameTabBarItem()
                } else if let childProfileNVC = child as? ChildProfileFeaturesNVC {
                    childProfileNVC.child = self.child
                    childProfileNVC.eventsText = ""
                    childProfileNVC.assignmentsText = ""
                    childProfileNVC.quizzesText = ""
                }
            }
        }
    }
    
    fileprivate func updateBadgeNumber(arrayIndex: Int) {
        if let notificationItem = tabBar.items?[arrayIndex] {
            notificationItem.badgeValue = getBadgeValue()
        }
    }
    
    func getBadgeValue() -> String {
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        if badgeNumber < 99 &&  badgeNumber > 0 {
            return "\(badgeNumber)"
        } else {
            return "+99"
        }
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
               if(self.isAnimating)
               {
                   self.stopAnimating()
               }
               self.sendFCM(token: "")
               let keychain = KeychainSwift()
               keychain.clear()
               let nvc = UINavigationController()
               let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
               nvc.pushViewController(schoolCodeVC, animated: true)
               nvc.modalPresentationStyle = .fullScreen
               self.present(nvc, animated: true, completion: nil)
           }))
           alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
           }))
           alert.modalPresentationStyle = .fullScreen
           self.present(alert, animated: true, completion: {
           })
       }
    
    func openSettings() {
        let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
            if Language.language == .arabic {
                self.showChangeLanguageConfirmation(language: .english)
            } else{
                self.showChangeLanguageConfirmation(language: .arabic)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
            if(self.isAnimating) {
                self.stopAnimating()
            }
            self.sendFCM(token: "")
            let keychain = KeychainSwift()
            keychain.clear()
            let nvc = UINavigationController()
            let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            nvc.pushViewController(schoolCodeVC, animated: true)
            nvc.modalPresentationStyle = .fullScreen
            self.present(nvc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
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
           alert.modalPresentationStyle = .fullScreen
           self.present(alert, animated: true, completion: nil)
       }
       
       func sendFCM(token: String) {
           startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
           let parameters: Parameters = ["user": ["mobile_device_token": token]]
           sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
               self.stopAnimating()
               if isSuccess {
                   debugPrint("UPDATED_FCM_SUCCESSFULLY")
               } else {
                   showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
               }
           }
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
