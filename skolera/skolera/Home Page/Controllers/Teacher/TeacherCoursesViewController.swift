//
//  TeacherCoursesViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/23/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TeacherCoursesViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var headerView: UIView!
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
        headerView.addShadow()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
//    MARK: - Swipe
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func getCourses() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getCoursesForTeacherAPI(teacherActableId: actor.actableId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
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
        let parentController = parent?.parent
        if let mainViewController = parentController as? TeacherContainerViewController {
            mainViewController.logout()
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
