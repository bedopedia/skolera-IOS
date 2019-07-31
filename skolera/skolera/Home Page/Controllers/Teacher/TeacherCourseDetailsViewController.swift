//
//  TeacherCourseDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCourseDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var course: TeacherCourse!
    var courseGroup: CourseGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = courseGroup.name
        for child in childViewControllers {
            if let teacherCourseDetailsTableViewController = child as? TeacherCourseDetailsTableViewController {
                teacherCourseDetailsTableViewController.course = self.course
                teacherCourseDetailsTableViewController.courseGroup = self.courseGroup
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
        
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
