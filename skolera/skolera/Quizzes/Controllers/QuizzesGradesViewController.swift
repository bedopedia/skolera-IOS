//
//  QuizzesGradesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class QuizzesGradesViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var submissions: [AssignmentStudentSubmission] = []
    var courseGroupId: Int = 0
    var courseId: Int = 0
    var quiz: FullQuiz!
    var quizName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.text = quizName
        getSubmissions()
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getSubmissions() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getQuizSubmissionsApi(courseGroupId: courseGroupId, quizId: quiz.id) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [[String: Any]] {
                    debugPrint(result)
                    self.submissions = result.map { AssignmentStudentSubmission($0) }
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func submitGrade(submission: AssignmentStudentSubmission, grade: String, feedback: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters: Parameters = ["score": grade,
                                      "student_id": submission.studentId ?? 0,
                                      "quiz_id": quiz.id!,
                                      "course_group_id": courseGroupId,
                                      "student_status": "present",
                                      "course_id": courseId
        ]
        submitQuizGradeApi(courseId: courseId, courseGroupId: courseGroupId, quizId: quiz.id, parameters: parameters) { (isSuccess, statusCode, value, error) in
            if isSuccess {
                if feedback.isEmpty {
                    SVProgressHUD.dismiss()
                    self.getSubmissions()
                } else {
                    self.submitFeedback(submissionId: self.quiz.id!, studentId: submission.studentId, feedback: feedback)
                }
            } else {
                SVProgressHUD.dismiss()
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func submitFeedback(submissionId: Int, studentId: Int, feedback: String) {
        let parameters: Parameters = ["feedback": [
            "content": feedback,
            "owner_id": userId(),
            "on_id": submissionId,
            "on_type": "Quiz",
            "to_id": studentId,
            "to_type": "Student"
            ]]
        debugPrint(parameters)
        submitAssignmentFeedbackApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.getSubmissions()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
}

extension QuizzesGradesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentSubmissionTableViewCell", for: indexPath) as! StudentSubmissionTableViewCell
        cell.isQuiz = true
        cell.studentSubmission = submissions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackDialog = FeedbackDialogViewController.instantiate(fromAppStoryboard: .Assignments)
        feedbackDialog.didSubmitGrade = { (grade, feedback) in
            self.submitGrade(submission: self.submissions[indexPath.row], grade: grade, feedback: feedback)
        }
        self.present(feedbackDialog, animated: true, completion: nil)
    }

}
