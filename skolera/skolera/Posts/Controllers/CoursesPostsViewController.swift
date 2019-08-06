//
//  CoursesPostsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class CoursesPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    var child : Child!
    var courseName: String = ""
    var courseId: Int = 0
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = courseName
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
         getPosts()
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getPosts(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        getPostsForCourseApi(courseId: courseId) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    if let postsArray = result["posts"] as? [[String: AnyObject]] {
                        self.posts = postsArray.map({ Post($0) })
                        self.tableView.reloadData()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        cell.post = posts[indexPath.row]
        cell.openAttachment = {
            let filesVC = PostResourcesViewController.instantiate(fromAppStoryboard: .Posts)
            filesVC.child = self.child
            filesVC.courseName = self.courseName
            filesVC.attachments = self.posts[indexPath.row].uploadedFiles ?? []
            self.navigationController?.pushViewController(filesVC, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postVC = PostDetailsViewController.instantiate(fromAppStoryboard: .Posts)
        postVC.child = self.child
        postVC.courseName = self.courseName
        postVC.post = posts[indexPath.row]
        self.navigationController?.pushViewController(postVC, animated: true)
    }

}
