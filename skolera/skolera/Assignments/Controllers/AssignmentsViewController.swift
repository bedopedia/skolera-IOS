//
//  AssignmentsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class AssignmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var placeholderLabel: UILabel!
    
    var child : Child!
    var isTeacher: Bool = false
    var courseName: String = ""
    var courseId: Int = 0
    var courseGroupId: Int = 0
    var assignments: [FullAssignment] = []
    var filteredAssignments: [FullAssignment]! {
        didSet {
            if self.filteredAssignments.isEmpty {
                if self.selectedSegment == 0{
                    self.placeholderLabel.text = "You don't have any open assignments for now".localized
                } else {
                    self.placeholderLabel.text = "You don't have any closed assignments for now".localized
                }
                placeholderView.isHidden = false
            } else {
                placeholderView.isHidden = true
            }
        }
    }
    var meta: Meta!
    var selectedSegment = 0
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = courseName
        tableView.delegate = self
        tableView.dataSource = self
        if isTeacher {
            childImageView.isHidden = true
        } else {
            if let child = child{
                childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
            }
        }
        statusSegmentControl.setTitleTextAttributes([.foregroundColor: getMainColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        statusSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        if isParent() {
            if #available(iOS 13.0, *) {
                statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            } else {
                statusSegmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            }
        } else {
            if isTeacher {
               if #available(iOS 13.0, *) {
                    statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8980392157, alpha: 1)
                } else {
                    statusSegmentControl.tintColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8980392157, alpha: 1)
                }
            }
            else {
                if #available(iOS 13.0, *) {
                    statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
                } else {
                    statusSegmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
                }
            }
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        getAssignments()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeDataSource(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegment = 0
            setOpenedAssignments()
        case 1:
            selectedSegment = 1
            setClosedAssignments()
        default:
            setOpenedAssignments()
        }
    }
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getAssignments()
        refreshControl.endRefreshing()
    }

    private func setOpenedAssignments() {
        filteredAssignments = assignments.filter({ $0.state.elementsEqual("running") })
        self.tableView.reloadData()
    }
    
    private func setClosedAssignments() {
        filteredAssignments = assignments.filter({ !$0.state.elementsEqual("running") })
        self.tableView.reloadData()
    }

    func getAssignments(){
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getAssignmentForCourseApi(courseId: courseId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.assignments = result.map({ FullAssignment($0) })
                    if self.selectedSegment == 0 {
                        self.setOpenedAssignments()
                    } else {
                        self.setClosedAssignments()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getAssignmentDetails(assignmentId: Int) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getAssignmentDetailsApi(courseId: courseId, assignmentId: assignmentId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let assignment = FullAssignment(result)
                    if !self.isTeacher {
                        let description = assignment.description ?? ""
                        if !description.isEmpty || assignment.uploadedFiles.count > 0 {
                           let assignmentDetailsVC: AssignmentDetailsViewController = AssignmentDetailsViewController.instantiate(fromAppStoryboard: .Assignments)
                            assignmentDetailsVC.child = self.child
                            assignmentDetailsVC.assignment = assignment
                            self.navigationController?.pushViewController(assignmentDetailsVC, animated: true)
                        } else {
                            let alert = UIAlertController(title: "Skolera", message: "No content available".localized, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
                            alert.modalPresentationStyle = .fullScreen
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let assignmentDetailsVC: AssignmentGradesViewController = AssignmentGradesViewController.instantiate(fromAppStoryboard: .Assignments)
                        assignmentDetailsVC.courseId = self.courseId
                        assignmentDetailsVC.courseGroupId = self.courseGroupId
                        assignmentDetailsVC.assignment = assignment
                        self.navigationController?.pushViewController(assignmentDetailsVC, animated: true)
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredAssignments != nil {
            return filteredAssignments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableViewCell") as! AssignmentTableViewCell
        cell.nameLabel.text = courseName
        cell.assignment = filteredAssignments[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getAssignmentDetails(assignmentId: filteredAssignments[indexPath.row].id)
            
    }
}
