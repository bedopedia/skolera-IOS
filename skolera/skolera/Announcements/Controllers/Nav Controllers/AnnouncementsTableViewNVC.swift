//
//  AnnouncementsTableViewNVC.swift
//  skolera
//
//  Created by Rana Hossam on 9/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AnnouncementsTableViewNVC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        updateTabBarItem(tab: .announcements, tabBarItem: tabBarItem)
    }
    
    func nameTabBarItem () {
//        tabBarItem.title = "Announcements"
//        tabBarItem.image = #imageLiteral(resourceName: "announcmentsNormal")
//        let userType = getUserType()
//        if userType == .student {
//            tabBarItem.selectedImage = UIImage(named: "studentActiveAnnouncmentsIcon")?.withRenderingMode(
//                .alwaysOriginal)
//        } else if userType == .parent {
//            tabBarItem.selectedImage = UIImage(named: "parentActiveAnnouncmentsIcon")?.withRenderingMode(
//                .alwaysOriginal)
//        } else {
//            tabBarItem.selectedImage = UIImage(named: "teacherActiveAnnouncment")?.withRenderingMode(
//                .alwaysOriginal)
//        }
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
