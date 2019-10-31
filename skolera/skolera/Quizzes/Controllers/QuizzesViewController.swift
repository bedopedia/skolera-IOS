//
//  QuizzesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import DateToolsSwift

class QuizzesViewController: UIViewController, NVActivityIndicatorViewable {
    
    var child : Child!
    var courseName: String = ""
    var courseId: Int = 0
    var quizzes: [FullQuiz] = []
    var filteredQuizzes: [FullQuiz] = []
    var isTeacher: Bool = false
    var courseGroupId = 0
    var pageId = 1
    var selectedSegment = 0
    var meta: Meta!
    private let refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    
    
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
        if isTeacher {
            getTeacherQuizzes()
        } else {
            getQuizzes(pageId: pageId)
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        if isTeacher {
            getTeacherQuizzes()
        } else {
            pageId = 1
            getQuizzes(pageId: pageId)
        }
        refreshControl.endRefreshing()
    }

    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeDataSource(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedSegment = 0
            setOpenedQuizzes()
        case 1:
            selectedSegment = 1
            setClosedQuizzes()
        default:
            setOpenedQuizzes()
        }
    }
    
    private func setOpenedQuizzes() {
        filteredQuizzes = quizzes.filter({ $0.state.elementsEqual("running") })
        self.tableView.reloadData()
    }
    
    private func setClosedQuizzes() {
        filteredQuizzes = quizzes.filter({ !$0.state.elementsEqual("running") })
        self.tableView.reloadData()
    }
    
    func getTeacherQuizzes() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizzesForTeacherApi(courseGroupId: courseGroupId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.quizzes = result.map({ FullQuiz($0) })
                    if self.selectedSegment == 1 {
                        self.setClosedQuizzes()
                    } else {
                        self.setOpenedQuizzes()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func getQuizzes(pageId: Int) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizzesForChildApi(childId: child.id, pageId: pageId, courseId: courseId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let quizResponse = QuizzesResponse(result)
                    if pageId == 1 {
                        self.quizzes = quizResponse.quizzes
                        self.checkQuizSubmission(quizzes: quizResponse.quizzes)
                        self.meta = quizResponse.meta
                    } else {
                        self.quizzes.append(contentsOf: quizResponse.quizzes)
                        self.checkQuizSubmission(quizzes: quizResponse.quizzes)
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func checkQuizSubmission(quizzes: [FullQuiz]) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        for quiz in quizzes {
            let now = Date()
            if let submission = quiz.studentSubmissions, let startDate = submission.createdAt {
                let startDate = dateFormatter.date(from: startDate)
                let duration = startDate?.add(TimeChunk.dateComponents(seconds: 0, minutes: quiz.duration ?? 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0))
                if now < duration ?? now {
                    if !submission.isSubmitted {
                        var parameters: [String: Any] = [:]
                        parameters["submission"] = ["id": submission.id ?? 0]
                        submitQuiz(parameters: parameters)
                    }
                }
            } else {
                continue
            }
        }
//        if count = 0
        if self.selectedSegment == 1 {
            self.setClosedQuizzes()
        } else {
            self.setOpenedQuizzes()
        }
    }
    
    func submitQuiz(parameters: Parameters) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        submitQuizApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                debugPrint("Quiz is submitted successfully")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
}

extension QuizzesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQuizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableViewCell") as! QuizTableViewCell
        cell.nameLabel.text = courseName
        cell.quiz = self.filteredQuizzes[indexPath.row]
//        cell.assignment = filteredAssignments[indexPath.row]
//        debugPrint("Index path: ",indexPath.row)
        if !getUserType().elementsEqual("teacher") {
            if indexPath.row >= filteredQuizzes.count - 2 {
                if meta.totalPages > pageId {
                    pageId += 1
                    getQuizzes(pageId: pageId)
                    if selectedSegment == 0 {
                        setOpenedQuizzes()
                    }
                    if selectedSegment == 1 {
                        setClosedQuizzes()
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isTeacher {
            let quizVC = QuizStatusViewController.instantiate(fromAppStoryboard: .Quizzes)
            quizVC.child = self.child
            quizVC.courseName = courseName
            quizVC.courseGroupId = courseGroupId
            quizVC.quiz = filteredQuizzes[indexPath.row]
            self.navigationController?.pushViewController(quizVC, animated: true)
            debugPrint("show quiz details")
        } else {
            let quizVC = QuizzesGradesViewController.instantiate(fromAppStoryboard: .Quizzes)
            quizVC.quizName = courseName
            quizVC.courseId = courseId
            quizVC.courseGroupId = courseGroupId
            quizVC.quiz = filteredQuizzes[indexPath.row]
            self.navigationController?.pushViewController(quizVC, animated: true)
        }
    }
}
