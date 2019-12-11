//
//  ContactTeacherNVC.swift
//  skolera
//
//  Created by Rana Hossam on 9/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class ContactTeacherNVC: UINavigationController {

    var child: Child! {
        didSet {
            for child in childViewControllers {
                if let contactTeacher = child as? ContactTeacherViewController {
                    contactTeacher.child = self.child
//                    self.nameTabBarItem()
                    updateTabBarItem(tab: .messages, tabBarItem: tabBarItem)
                }
            }
        }
    }
    
    var actor: Actor! {
        didSet {
            for child in childViewControllers {
                if let contactTeacher = child as? ContactTeacherViewController {
                    contactTeacher.actor = self.actor
//                    self.nameTabBarItem()
                    updateTabBarItem(tab: .messages, tabBarItem: tabBarItem)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
//        debugPrint("contact teacher nvc")
//        self.interactivePopGestureRecognizer?.isEnabled = true
//        self.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func nameTabBarItem () {
        tabBarItem.title = "Messages"
        tabBarItem.image = #imageLiteral(resourceName: "messagesNormal")
        let userType = getUserType()
        if userType == .student {
            tabBarItem.selectedImage = UIImage(named: "studentActiveMessageIcon")?.withRenderingMode(
                .alwaysOriginal)
        } else if userType == .parent {
            tabBarItem.selectedImage = UIImage(named: "parentActiveMessageIcon")?.withRenderingMode(
                .alwaysOriginal)
        } else {
            tabBarItem.selectedImage = UIImage(named: "teacherActiveMessage")?.withRenderingMode(
                .alwaysOriginal)
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
