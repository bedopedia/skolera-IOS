//
//  AssignmentDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class AssignmentDetailsViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var child : Child!
    var assignment: FullAssignment!
    var courseId: Int!
    var assignmentId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        getAssignmentDetails(assignmentId: assignmentId!)
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getAssignmentDetails(assignmentId: Int) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getAssignmentDetailsApi(courseId: courseId, assignmentId: assignmentId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    self.assignment = FullAssignment(result)
                    self.titleLabel.text = self.assignment.name
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }

}

extension AssignmentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if assignment != nil {
            return 1 + self.assignment.uploadedFiles.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentContentTableViewCell") as! AssignmentContentTableViewCell
            if let content = self.assignment.content {
//                cell.label.attributedText = content.htmlToAttributedString
                cell.label.update(input: content)
            } else {
//                cell.label.text = "No content".localized
                cell.label.update(input: "No content".localized)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentTableViewCell") as! AttachmentTableViewCell
            cell.uploadedFile = self.assignment.uploadedFiles[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if let url = URL(string: self.assignment.uploadedFiles[indexPath.row - 1].url ?? "") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
