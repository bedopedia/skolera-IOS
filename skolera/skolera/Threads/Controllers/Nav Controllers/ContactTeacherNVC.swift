//
//  ContactTeacherNVC.swift
//  skolera
//
//  Created by Rana Hossam on 9/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class ContactTeacherNVC: UINavigationController {

    var student: Actor! {
        didSet {
            for child in childViewControllers {
                if let contactTeacher = child as? ContactTeacherViewController {
                    contactTeacher.child = self.student
                    updateTabBarItem(tab: .messages, tabBarItem: tabBarItem)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
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


}
