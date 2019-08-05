//
//  TeacherCourseDetailsTableViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCourseDetailsTableViewController: UITableViewController {
    
    var course: TeacherCourse!
    var courseGroup: CourseGroup!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let quizVC = QuizzesViewController.instantiate(fromAppStoryboard: .Quizzes)
            quizVC.isTeacher = true
            quizVC.courseName = course.name
            quizVC.courseId = course.id
            self.navigationController?.pushViewController(quizVC, animated: true)
        } else if indexPath.row == 1 {
            let assignmentsVC = AssignmentsViewController.instantiate(fromAppStoryboard: .Assignments)
            assignmentsVC.isTeacher = true
            assignmentsVC.courseName = course.name
            assignmentsVC.courseId = course.id
            self.navigationController?.pushViewController(assignmentsVC, animated: true)
        }
    }
}
