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
import SkeletonView

class CoursesPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, SkeletonTableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet var gradientView: GradientView!
    
    var child : Actor!
    var courseName: String = ""
    var courseId: Int = 0
    var courseGroup: CourseGroup!
    var posts: [Post]!
    var meta: Meta!
    var isTeacher: Bool = false
    private let refreshControl = UIRefreshControl()
    var isRetrievingData = true
    
    
//    MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = courseName
        tableView.delegate = self
        tableView.dataSource = self
        if isTeacher {
            childImageView.isHidden = true
            gradientView.isHidden = true
            let footerView = UIView.init(frame: .init(x: 0, y: 0, width: 10, height: 60))
            footerView.backgroundColor = .clear
            tableView.tableFooterView = footerView
        } else {
            createPostButton.isHidden = true
            if let child = child {
                childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
            }
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.showAnimatedSkeleton()
        refreshData()
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createPost() {
        debugPrint("create post")
        let createPost = CreatePostViewController.instantiate(fromAppStoryboard: .Posts)
        createPost.courseGroup = courseGroup
        self.navigationController?.pushViewController(createPost, animated: true)
    }
    
    @objc private func refreshData() {
        getPosts()
        fixSkeletonHeight()
        self.tableView.showAnimatedSkeleton()
        refreshControl.endRefreshing()
    }
    
    fileprivate func fixSkeletonHeight() {
        tableView.estimatedRowHeight = 146
        tableView.rowHeight = 146
    }

    func getPosts(page: Int = 1) {
        isRetrievingData = true
        var id: Int
        if isTeacher {
            id = courseGroup.id
        } else {
            id = courseId
        }
        getPostsForCourseApi(page: page,courseId: id) { (isSuccess, statusCode, value, error) in
            if self.posts == nil {
                self.posts = []
            }
            if page == 1 {
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                self.tableView.hideSkeleton()
                self.posts = []
                self.tableView.reloadData()
            }
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    if let postsArray = result["posts"] as? [[String: AnyObject]] {
                        self.posts.append(contentsOf: postsArray.map({ Post($0) }))
                        self.meta = Meta(fromDictionary: result["meta"] as! [String : Any])
                        self.tableView.rowHeight = UITableViewAutomaticDimension
                        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                        self.tableView.reloadData()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            self.isRetrievingData = false
            handleEmptyDate(tableView: self.tableView, dataSource: self.posts ?? [], imageName: "postsplaceholder", placeholderText: "You don't have any posts for now".localized)
        }
    }
    
//    MARK: -Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts != nil {
            if posts.isEmpty {
                return 0
            } else {
                return posts.count
            }
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        if posts != nil {
            cell.hideSkeleton()
            cell.postImageView.image = nil
            cell.attachmentView.isHidden = false
            cell.post = posts[indexPath.row]
            if indexPath.row == posts.count - 5  && !isRetrievingData {
                if meta.currentPage != meta.totalPages{
//                    fixSkeletonHeight()
                    getPosts(page: (meta.currentPage)! + 1)
                }
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
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "PostTableViewCell"
    }

}
