//
//  TeacherCoursesViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/23/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SkeletonView

class TeacherCoursesViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var courses: [TeacherCourse] = []
    var actor: Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        self.tableView.estimatedRowHeight = 80
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.tableView.showSkeleton()
        if actor != nil {
            getCourses()
        }
    }

//    MARK: - Swipe
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func getCourses() {
        getCoursesForTeacherAPI(teacherActableId: actor.childId) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    let teacherCourses: [TeacherCourse] = result.map({ TeacherCourse($0) })
                    self.courses = teacherCourses
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func getText(name: String) -> String {
        let shortcut = name.replacingOccurrences(of: "&", with: "")
        if shortcut.split(separator: " ").count == 1 {
            //            return "\(shortcut.first!)"
            return String(shortcut.prefix(2))
        } else {
            return "\(shortcut.split(separator: " ")[0].first!)\(shortcut.split(separator: " ")[1].first!)"
        }
        
    }
    
    @IBAction func logout() {
        let settingsVC = SettingsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        navigationController?.pushViewController(settingsVC, animated: true)
    }

}

extension TeacherCoursesViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TeacherCourseTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !courses.isEmpty {
            return courses.count
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCourseTableViewCell") as! TeacherCourseTableViewCell
        if courses.count > indexPath.row {
            cell.hideSkeleton()
            cell.course = courses[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseGroupsVC: TeacherCourseGroupViewController = TeacherCourseGroupViewController.instantiate(fromAppStoryboard: .HomeScreen)
            courseGroupsVC.course = self.courses[indexPath.row]
            self.navigationController?.pushViewController(courseGroupsVC, animated: true)
    }
    
}
