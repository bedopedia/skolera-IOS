//
//  TeacherCourseDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCourseDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var course: TeacherCourse!
    var courseGroup: CourseGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = courseGroup.name
        for child in children {
            if let teacherCourseDetailsTableViewController = child as? TeacherCourseDetailsTableViewController {
                teacherCourseDetailsTableViewController.course = self.course
                teacherCourseDetailsTableViewController.courseGroup = self.courseGroup
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//        if let parentVc = parent?.parent as? TeacherContainerViewController {
//            parentVc.headerHeightConstraint.constant = 0
//            parentVc.headerView.isHidden = true
//        }
//    }
//   
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let parentVC = parent?.parent as? TeacherContainerViewController {
//            parentVC.headerHeightConstraint.constant = 60
//            parentVC.headerView.isHidden = false
//        }
//    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
        
    }
}
