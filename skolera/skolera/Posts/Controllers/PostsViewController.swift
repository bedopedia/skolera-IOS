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

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet var placeHolderView: UIView!
    
    var child : Child!
    var courses: [PostCourse]! {
        didSet {
            if self.courses.isEmpty {
                placeHolderView.isHidden = false
            } else {
                placeHolderView.isHidden = true
            }
        }
    }
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
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
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getPostsCoursesApi(childId: child.id) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if self.courses == nil {
                self.courses = []
            }
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.courses = result.map({ PostCourse($0) })
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    //    MARK: - Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if courses != nil {
           return courses.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseGroupPostTableViewCell") as! CourseGroupPostTableViewCell
        cell.course = self.courses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postsVC = CoursesPostsViewController.instantiate(fromAppStoryboard: .Posts)
        postsVC.child = self.child
        postsVC.courseName = courses[indexPath.row].courseName ?? ""
        postsVC.courseId = courses[indexPath.row].id!
        self.navigationController?.pushViewController(postsVC, animated: true)
    }
    
}
