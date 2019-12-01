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

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource  {
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var child : Child!
    var courses: [PostCourse]!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.register(UINib(nibName: "SkeletonTableViewCell", bundle: nil), forCellReuseIdentifier: "SkeletonTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 85
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        getCourses()
    }
   
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //    MARK: - Methods
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getCourses()
        refreshControl.endRefreshing()
    }
    func getCourses(){
        self.tableView.showAnimatedSkeleton()
        getPostsCoursesApi(childId: child.id) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
            self.courses = []
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.courses = result.map({ PostCourse($0) })
                    self.tableView.reloadData()
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
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseGroupPostTableViewCell") as! CourseGroupPostTableViewCell
        if courses != nil {
            cell.hideSkeleton()
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
        return "SkeletonTableViewCell"
//        //////////////////
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
