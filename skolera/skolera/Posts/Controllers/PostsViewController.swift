//
//  PostsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SkeletonView

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, SkeletonTableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var child : Child!
    var courses: [PostCourse]!
    private let refreshControl = UIRefreshControl()
    
    fileprivate func fixTableViewHeight() {
        tableView.rowHeight = 170
        tableView.estimatedRowHeight = 170
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        fixTableViewHeight()
        getCourses()
        
        
    }
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //    MARK: - Methods
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        fixTableViewHeight()
        getCourses()
        refreshControl.endRefreshing()
    }
    func getCourses() {
        tableView.showAnimatedSkeleton()
        getPostsCoursesApi(childId: child.id) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if self.courses == nil {
                self.courses = []
            }
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.courses = result.map({ PostCourse($0) })
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.courses, imageName: "postsplaceholder", placeholderText: "You don't have any courses for now".localized)
        }
    }
    //    MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courses != nil {
            if !courses.isEmpty {
                return courses.count
            } else {
                return 0
            }
        }
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseGroupPostTableViewCell") as! CourseGroupPostTableViewCell
        cell.hideSkeleton()
        if courses != nil {
            cell.course = self.courses[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postsVC = CoursesPostsViewController.instantiate(fromAppStoryboard: .Posts)
        postsVC.child = self.child
        postsVC.courseName = courses[indexPath.row].courseName ?? ""
        postsVC.courseId = courses[indexPath.row].id!
        self.navigationController?.pushViewController(postsVC, animated: true)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CourseGroupPostTableViewCell"
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if let result = self.courses {
//            if result.isEmpty {
//                return tableView.bounds.size.height
//            } else {
//                return UITableViewAutomaticDimension
//            }
//        } else {
//            return tableView.bounds.size.height
//        }
//    }
//
}
