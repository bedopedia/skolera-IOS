//
//  AssignmentGradesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class AssignmentGradesViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    private var submissions: [AssignmentStudentSubmission] = []
    var courseId: Int = 0
    var courseGroupId: Int = 0
    var assignment: FullAssignment!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = assignment.name
        tableView.delegate = self
        tableView.dataSource = self
        getSubmissions()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getSubmissions()
        refreshControl.endRefreshing()
    }

    private func getSubmissions() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getAssignmentSubmissionsApi(courseId: courseId, courseGroupId: courseGroupId, assignmentId: assignment.id) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String: Any]] {
                    self.submissions = result.map { AssignmentStudentSubmission($0) }
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func submitGrade(submission: AssignmentStudentSubmission, grade: String, feedback: String) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters: Parameters = ["grade": grade,
                                      "student_id": submission.studentId ?? 0,
                                      "assignment_id": assignment.id!,
                                      "course_group_id": courseGroupId,
                                      "student_status": "present",
                                      "course_id": courseId
        ]
        submitAssignmentGradeApi(courseId: courseId, courseGroupId: courseGroupId, assignmentId: assignment.id, parameters: parameters) { (isSuccess, statusCode, value, error) in
            if isSuccess {
                if feedback.isEmpty {
                    self.stopAnimating()
                    self.getSubmissions()
                } else {
                    self.submitFeedback(submissionId: self.assignment.id!, studentId: submission.studentId, feedback: feedback)
                }
            } else {
                self.stopAnimating()
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func submitFeedback(submissionId: Int, studentId: Int, feedback: String) {
        let parameters: Parameters = ["feedback": [
            "content": feedback,
            "owner_id": userId(),
            "on_id": submissionId,
            "on_type": "Assignment",
            "to_id": studentId,
            "to_type": "Student"
        ]]
        submitAssignmentFeedbackApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                self.getSubmissions()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }

}

extension AssignmentGradesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentSubmissionTableViewCell", for: indexPath) as! StudentSubmissionTableViewCell
        cell.studentSubmission = self.submissions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentSubmission = self.submissions[indexPath.row]
        if let graded = studentSubmission.graded, graded {
            debugPrint("already graded")
        } else {
            let feedbackDialog = FeedbackDialogViewController.instantiate(fromAppStoryboard: .Assignments)
            feedbackDialog.didSubmitGrade = { grade, feedback in
                self.submitGrade(submission: studentSubmission, grade: grade, feedback: feedback)
            }
            feedbackDialog.modalPresentationStyle = .overCurrentContext
            self.present(feedbackDialog, animated: true, completion: nil)
        }
        
    }
    
    
}
