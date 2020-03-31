//
//  AssignmentDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SkeletonView


class AssignmentDetailsViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var imageViewBackground: GradientView!
    
    var child : Actor!
    var assignment: FullAssignment!
    var courseId: Int!
    var assignmentId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if getUserType() == UserType.teacher {
            childImageView.isHidden = true
            imageViewBackground.isHidden = true
        } else {
            if let child = child{
                childImageView.isHidden = false
                imageViewBackground.isHidden = false
                childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first ?? Character(" "))\(child.lastname.first ?? Character(" "))", textSize: 14)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
        self.titleLabel.text = self.assignment.name
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension AssignmentDetailsViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
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
                cell.label.update(input: content)
            } else {
                cell.label.update(input: "No content".localized)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentTableViewCell") as! AttachmentTableViewCell
            cell.hideSkeleton()
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
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AttachmentTableViewCell"
    }
    
}
