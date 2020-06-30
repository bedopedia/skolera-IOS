//
//  AssignmentCoursesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 6/12/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SkeletonView

class AssignmentCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, SkeletonTableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var child : Actor!
    var courses: [AssignmentCourse]!
    var meta: Meta!
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child {
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first ?? Character(" "))\(child.lastname.first ?? Character(" "))", textSize: 14)
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func refreshData() {
        fixTableViewHeight()
        tableView.showAnimatedSkeleton()
        getCourses()
        refreshControl.endRefreshing()
    }
    
    fileprivate func fixTableViewHeight() {
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
    }
    
    func getCourses() {
        if courses == nil {
            courses = []
        }
        getAssignmentCoursesApi(childId: child.childId) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    debugPrint(result)
                    let assignmentCourses: [AssignmentCourse] = result.map({ AssignmentCourse($0) })
                    self.courses = assignmentCourses
                    self.tableView.rowHeight = UITableView.automaticDimension
                    self.tableView.estimatedRowHeight = UITableView.automaticDimension
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.courses ?? [], imageName: "assignmentsplaceholder", placeholderText: "You don't have any courses for now".localized)
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courses != nil {
            return courses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCourseTableViewCell") as! AssignmentCourseTableViewCell
        if courses != nil {
            cell.hideSkeleton()
            cell.course = courses[indexPath.row]
        }
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AssignmentCourseTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignmentsVC = AssignmentsViewController.instantiate(fromAppStoryboard: .Assignments)
        assignmentsVC.child = self.child
        assignmentsVC.courseName = courses[indexPath.row].courseName
        assignmentsVC.courseId = courses[indexPath.row].courseId
        self.navigationController?.pushViewController(assignmentsVC, animated: true)
    }

}
