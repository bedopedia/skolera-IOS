//
//  PostDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class PostDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var child : Child!
    var courseName: String = ""
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        titleLabel.text = courseName
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        replyTextField.delegate = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func send(){
        if let text = replyTextField.text, !text.isEmpty {
            startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
            let parameters : Parameters = ["comment": ["content": text, "owner_id": userId(), "post_id": self.post.id!]]
            addPostReplyApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
                self.stopAnimating()
                if isSuccess {
                    if let result = value as? [String: AnyObject] {
                        let comment: PostComment = PostComment(result)
                        self.post.comments?.append(comment)
                        self.tableView.reloadData()
                    }
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        }
        replyTextField.text = ""
        replyView.isHidden = true
        self.view.endEditing(true)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + (post.comments?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostDetailsTableViewCell") as! PostDetailsTableViewCell
        if indexPath.row == 0 {
            cell.post = post
            cell.openAttachment = {
                let filesVC = PostResourcesViewController.instantiate(fromAppStoryboard: .Posts)
                filesVC.child = self.child
                filesVC.courseName = self.courseName
                filesVC.attachments = self.post.uploadedFiles ?? []
                self.navigationController?.pushViewController(filesVC, animated: true)
            }
            cell.addPostReply = {
                debugPrint("Add reply")
                self.replyView.isHidden = false
                self.replyTextField.becomeFirstResponder()
            }
        } else {
            cell.comment = post.comments![indexPath.row - 1]
        }
        
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        send()
        textField.text = ""
        replyView.isHidden = true
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
        replyView.isHidden = true
    }
}
