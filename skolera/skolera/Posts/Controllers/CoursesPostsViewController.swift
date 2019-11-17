//
//  CoursesPostsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class CoursesPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet var placeHolderView: UIView!
    @IBOutlet var headerView: UIView!
    
    var child : Child!
    var courseName: String = ""
    var courseId: Int = 0
    var courseGroup: CourseGroup!
    var posts: [Post]! {
        didSet {
            if self.posts.isEmpty {
                placeHolderView.isHidden = false
            } else {
                placeHolderView.isHidden = true
            }
        }
    }
    var meta: Meta!
    var isTeacher: Bool = false
    private let refreshControl = UIRefreshControl()

    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = courseName
        tableView.delegate = self
        tableView.dataSource = self
        if isTeacher {
            childImageView.isHidden = true
            let footerView = UIView.init(frame: .init(x: 0, y: 0, width: 10, height: 60))
            footerView.backgroundColor = .clear
            tableView.tableFooterView = footerView
        } else {
            createPostButton.isHidden = true
            if let child = child{
                childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
            }
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
        getPosts()
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createPost() {
        debugPrint("create post")
        let createPost = CreatePostViewController.instantiate(fromAppStoryboard: .Posts)
        createPost.courseGroup = courseGroup
//        self.present(createPost, animated: true, completion: nil)
        self.navigationController?.pushViewController(createPost, animated: true)
    }
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getPosts()
        refreshControl.endRefreshing()
    }

    func getPosts(page: Int = 1){
        var id: Int
        if isTeacher {
            id = courseGroup.id
        } else {
            id = courseId
        }
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getPostsForCourseApi(page: page,courseId: id) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if self.posts == nil {
                self.posts = []
            }
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    if let postsArray = result["posts"] as? [[String: AnyObject]] {
                        self.posts.append(contentsOf: postsArray.map({ Post($0) }))
                        self.meta = Meta(fromDictionary: result["meta"] as! [String : Any])
                        self.tableView.reloadData()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
//    MARK: -Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
           return posts.count
        } else {
            self.tableView.backgroundView = self.placeHolderView
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        cell.post = posts[indexPath.row]
        if indexPath.row == posts.count - 1{
            if meta.currentPage != meta.totalPages{
                getPosts(page: (meta.currentPage)! + 1)
            }
        }
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
        self.navigationController?.navigationController?.pushViewController(postVC, animated: true)
//        self.navigationController?.pushViewController(postVC, animated: true)
    }

}
