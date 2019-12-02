//
//  GradesTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/4/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SkeletonView

class GradesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, SkeletonTableViewDataSource {
    //TODO:- REMAINING SCREEN FOR GRADES DETAILS
    //MARK: - Variables
    var child : Child!
    /// date source for tableView
    var gradesCourses: [PostCourse]!
    //MARK: - Outlets
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.delegate = self
        tableView.dataSource = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        fixTableViewHeight()
        tableView.showAnimatedSkeleton()
        getGradesCourses()
    }
    func fixTableViewHeight() {
        tableView.rowHeight = 85
        tableView.estimatedRowHeight = 85
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getGradesCourses() {
        if gradesCourses == nil {
            gradesCourses = []
        }
        getPostsCoursesApi(childId: child.actableId!) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.gradesCourses = result.map({ PostCourse($0) })
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = 85
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.gradesCourses ?? [], imageName: "gradesplaceholder", placeholderText: "You don't have any courses for now".localized)
        }
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gradesCourses != nil {
            return gradesCourses.count
        } else {
            return 6
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseGradeCell", for: indexPath) as! CourseGradeCell
        if gradesCourses != nil {
            cell.hideSkeleton()
            cell.grade = gradesCourses[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CourseGradeCell
        let cgVC = CourseGradeViewController.instantiate(fromAppStoryboard: .Grades)
        cgVC.child = child
        cgVC.grade = cell.grade
        self.navigationController?.pushViewController(cgVC, animated: true)
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "courseGradeCell"
    }

}
