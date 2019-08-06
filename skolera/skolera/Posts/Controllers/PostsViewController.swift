//
//  PostsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var child : Child!

    var courses: [PostCourse] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        getCourses()
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    

    func getCourses(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        getPostsCoursesApi(childId: child.id) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
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
        postsVC.courseId = courses[indexPath.row].courseId!
        self.navigationController?.pushViewController(postsVC, animated: true)
    }

}
