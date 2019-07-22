//
//  PostDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class PostDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyTextField: UITextField!
    @IBOutlet weak var replyView: UIView!
    
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
    }
    
    @IBAction func send(){
        if let text = replyTextField.text, !text.isEmpty {
            SVProgressHUD.show(withStatus: "Loading".localized)
            let parameters : Parameters = ["comment": ["content": text, "owner_id": userId(), "post_id": self.post.id!]]
            debugPrint(parameters)
            let headers : HTTPHeaders? = getHeaders()
            let url = COMMENTS_URL()
            Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
                SVProgressHUD.dismiss()
                switch response.result{
                case .success(_):
                    if let result = response.result.value  as? [String: AnyObject] {
                        debugPrint(result)
                        let comment: PostComment = PostComment(result)
                        self.post.comments?.append(comment)
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                    {
                        showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                    }
                    else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                    {
                        showReauthenticateAlert(viewController: self)
                    }
                    else
                    {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
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
