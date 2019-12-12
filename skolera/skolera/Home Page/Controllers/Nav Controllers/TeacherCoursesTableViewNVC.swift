//
//  TeacherCoursesTableViewNVC.swift
//  skolera
//
//  Created by Rana Hossam on 9/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCoursesTableViewNVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
        updateTabBarItem(tab: .courses, tabBarItem: tabBarItem)
//        self.interactivePopGestureRecognizer?.isEnabled = true
//        self.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
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
