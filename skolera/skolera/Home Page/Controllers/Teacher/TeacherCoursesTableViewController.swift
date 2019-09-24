//
//  TeacherCoursesTableViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class TeacherCoursesTableViewController: UITableViewController {
    
    var courses: [TeacherCourse] = []

    
    var actor: Actor!{
        didSet {
            if actor != nil {
                getCourses()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if actor != nil {
            getCourses()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(parent, parent?.parent)
        if let parentVC = parent?.parent as? TeacherContainerViewController {
//            parentVC.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//            parentVC.headerView.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let parentVc = parent?.parent as? TeacherContainerViewController {
//            parentVc.headerHeightConstraint.constant = 0
//            parentVc.headerView.isHidden = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.courses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseGroupsVC: TeacherCourseGroupViewController = TeacherCourseGroupViewController.instantiate(fromAppStoryboard: .HomeScreen)
        courseGroupsVC.course = self.courses[indexPath.row]
        self.navigationController?.pushViewController(courseGroupsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCourseTableViewCell") as! TeacherCourseTableViewCell
        cell.course = courses[indexPath.row]
        return cell
    }
    
    func getCourses() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getCoursesForTeacherAPI(teacherActableId: actor.actableId) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
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

}
