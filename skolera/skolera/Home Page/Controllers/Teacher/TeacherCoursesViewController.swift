//
//  TeacherCoursesViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/23/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD


class TeacherCoursesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
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
        self.tableView.dataSource = self
        self.tableView.delegate = self

        // Do any additional setup after loading the view.
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
            parentVC.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
            parentVC.headerView.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let parentVc = parent?.parent as? TeacherContainerViewController {
            parentVc.headerHeightConstraint.constant = 0
            parentVc.headerView.isHidden = true
        }
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

extension TeacherCoursesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCourseTableViewCell") as! TeacherCourseTableViewCell
        cell.course = courses[indexPath.row]
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
