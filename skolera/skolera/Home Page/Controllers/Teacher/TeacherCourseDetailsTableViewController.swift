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
//        debugPrint(parent)
//        debugPrint(parent?.parent)
//        debugPrint(parent?.parent?.parent)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            let quizVC = QuizzesViewController.instantiate(fromAppStoryboard: .Quizzes)
//            quizVC.isTeacher = true
//            quizVC.courseName = course.name
//            quizVC.courseId = course.id
//            quizVC.courseGroupId = courseGroup.id
//            self.navigationController?.pushViewController(quizVC, animated: true)
//        } else if indexPath.row == 1 {
//            let assignmentsVC = AssignmentsViewController.instantiate(fromAppStoryboard: .Assignments)
//            assignmentsVC.isTeacher = true
//            assignmentsVC.courseName = course.name
//            assignmentsVC.courseId = course.id
//            assignmentsVC.courseGroupId = courseGroup.id
//            self.navigationController?.pushViewController(assignmentsVC, animated: true)
//        } else if indexPath.row == 2 {
//            let postsVC = CoursesPostsViewController.instantiate(fromAppStoryboard: .Posts)
//            postsVC.courseName = course.name ?? ""
//            postsVC.courseId = course.id!
//            postsVC.courseGroup = courseGroup
//            postsVC.isTeacher = true
//            self.navigationController?.pushViewController(postsVC, animated: true)
//        }
        
        if indexPath.row == 0 {
            let attendanceVC = TeacherAttendanceViewController.instantiate(fromAppStoryboard: .Attendance)
            self.navigationController?.pushViewController(attendanceVC, animated: true)
//            debugPrint("Open the attendance view controller")
        } else if indexPath.row == 1 {
            let quizVC = QuizzesViewController.instantiate(fromAppStoryboard: .Quizzes)
            quizVC.isTeacher = true
            quizVC.courseName = course.name
            quizVC.courseId = course.id
            quizVC.courseGroupId = courseGroup.id
            self.navigationController?.pushViewController(quizVC, animated: true)
        } else if indexPath.row == 2 {
            let assignmentsVC = AssignmentsViewController.instantiate(fromAppStoryboard: .Assignments)
            assignmentsVC.isTeacher = true
            assignmentsVC.courseName = course.name
            assignmentsVC.courseId = course.id
            assignmentsVC.courseGroupId = courseGroup.id
            self.navigationController?.pushViewController(assignmentsVC, animated: true)
        } else if indexPath.row == 3 {
            let postsVC = CoursesPostsViewController.instantiate(fromAppStoryboard: .Posts)
            postsVC.courseName = course.name ?? ""
            postsVC.courseId = course.id!
            postsVC.courseGroup = courseGroup
            postsVC.isTeacher = true
            self.navigationController?.pushViewController(postsVC, animated: true)
        }
    }
}
