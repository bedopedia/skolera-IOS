//
//  QuizzesCoursesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SkeletonView

class QuizzesCoursesViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var child : Actor!
    var courses: [QuizCourse]!
    var meta: Meta!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child {
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
    }
    
    @objc private func refreshData() {
        fixTableViewHeight()
        self.tableView.showAnimatedSkeleton()
        getCourses()
        refreshControl.endRefreshing()
    }

    func fixTableViewHeight() {
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCourses() {
        if courses == nil {
            courses = []
        }
        getQuizzesCoursesApi(childId: child.id) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    debugPrint(result)
                    let quizCourses: [QuizCourse] = result.map({ QuizCourse($0) })
                    self.courses = quizCourses
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.courses, imageName: "quizzesplaceholder", placeholderText: "You don't have any courses for now".localized)
        }
    }
}

extension QuizzesCoursesViewController: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courses != nil {
         return courses.count
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCourseTableViewCell") as! QuizCourseTableViewCell
        if courses != nil {
            cell.hideSkeleton()
           cell.course = courses[indexPath.row]
        }
        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "QuizCourseTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizVC = QuizzesViewController.instantiate(fromAppStoryboard: .Quizzes)
        quizVC.child = self.child
        quizVC.courseName = courses[indexPath.row].courseName
        quizVC.courseId = courses[indexPath.row].courseId
        quizVC.courseGroupId = courses[indexPath.row].id
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
}
