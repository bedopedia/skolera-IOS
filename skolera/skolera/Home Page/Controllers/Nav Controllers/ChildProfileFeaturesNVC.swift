//
//  ChildProfileFeaturesNVC.swift
//  skolera
//
//  Created by Rana Hossam on 9/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class ChildProfileFeaturesNVC: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    var child: Child! {
        didSet {
            if let childVc =  childViewControllers[0] as? ChildProfileViewController {
                childVc.child = self.child
                childVc.assignmentsText = self.assignmentsText
                childVc.quizzesText = self.quizzesText
                childVc.eventsText = self.eventsText
            }
        }
    }
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        updateTabBarItem(tab: .home, tabBarItem: tabBarItem)
//        self.delegate = self
//        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if let childVc =  childViewControllers[0] as? ChildProfileViewController {
//            childVc.child = self.child
//            childVc.assignmentsText = self.assignmentsText
//            childVc.quizzesText = self.quizzesText
//            childVc.eventsText = self.eventsText
//            childVc.addChildImage()
//            childVc.addChildData()
//        }
        
//        for child in childViewControllers {
//            if let childNvc = child as? ContactTeacherNVC {
//                childNvc.child = self.child
//            }
//        }
    }
    fileprivate func updateTabBarItem(tab: Tabs, tabBarItem: UITabBarItem) {
        if getUserType() == .student {
            tabBarItem.selectedImage = UIImage(named: "studentActiveBookIcon")?.withRenderingMode(
                .alwaysOriginal)
            tabBarItem.image = #imageLiteral(resourceName: "unselectedCourses")
            tabBarItem.title = "Home".localized
        } else {
            tabBarItem.selectedImage = UIImage(named: "parentActiveMoreIcon")?.withRenderingMode(
                .alwaysOriginal)
            tabBarItem.image = #imageLiteral(resourceName: "parentMoreIcon")
            tabBarItem.title = "Menu".localized
            //            #imageLiteral(resourceName: "parentActiveMoreIcon")
        }
       }
    
    // MARK: - Swipe
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
