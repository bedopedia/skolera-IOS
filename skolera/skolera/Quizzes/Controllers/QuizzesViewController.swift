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
import SwiftDate
import SkeletonView

class QuizzesViewController: UIViewController, NVActivityIndicatorViewable {
    
    var child : Actor!
    var courseName: String = ""
    var courseId: Int = 0
    var quizzes: [FullQuiz]!
    var filteredQuizzes: [FullQuiz] = []
    var isTeacher: Bool = false
    var courseGroupId = 0
    var pageId = 1
    var selectedSegment = 0
    var meta: Meta!
    var count = 0
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    
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
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
    }
    
    @objc private func refreshData() {
        tableView.rowHeight = 104
        tableView.estimatedRowHeight = 104
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
            setOnHoldQuizzes()
        case 2:
            selectedSegment = 2
            setClosedQuizzes()
        default:
            setOpenedQuizzes()
        }
    }
    
    private func setOpenedQuizzes() {
        if quizzes != nil {
            filteredQuizzes = quizzes.filter({ $0.state.elementsEqual("running") })
            handleEmptyDate(tableView: self.tableView, dataSource: self.filteredQuizzes, imageName: "quizzesplaceholder", placeholderText: "You don't have any open quizzes for now".localized)
            self.tableView.reloadData()
        }
    }
    
    private func setClosedQuizzes() {
        if quizzes != nil {
            filteredQuizzes = quizzes.filter({ !$0.state.elementsEqual("running") })
            handleEmptyDate(tableView: self.tableView, dataSource: self.filteredQuizzes, imageName: "quizzesplaceholder", placeholderText: "You don't have any closed quizzes for now".localized)
            self.tableView.reloadData()
        }
    }
    
    private func setOnHoldQuizzes() {
           if quizzes != nil {
               filteredQuizzes = quizzes.filter({ $0.state.elementsEqual("on_hold") })
               handleEmptyDate(tableView: self.tableView, dataSource: self.filteredQuizzes, imageName: "quizzesplaceholder", placeholderText: "You don't have any on hold quizzes for now".localized)
               self.tableView.reloadData()
           }
       }
    
    func getTeacherQuizzes() {
        if quizzes == nil {
            quizzes = []
        }
        self.tableView.showAnimatedSkeleton()
        getQuizzesForTeacherApi(courseGroupId: courseGroupId) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.quizzes = result.map({ FullQuiz($0) })
                    if self.selectedSegment == 0 {
                        self.setOpenedQuizzes()
                    } else if self.selectedSegment == 1 {
                        self.setOnHoldQuizzes()
                    } else {
                        self.setClosedQuizzes()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func getQuizzes(pageId: Int) {
        if quizzes == nil {
            quizzes = []
            self.tableView.showAnimatedSkeleton()
        }
        getQuizzesForChildApi(childId: child.id, pageId: pageId, courseId: courseGroupId) { (isSuccess, statusCode, value, error) in
            if self.quizzes.isEmpty {
                self.tableView.hideSkeleton()
            }
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let quizResponse = QuizzesResponse(result)
                    self.quizzes = quizResponse.quizzes
                    self.checkQuizSubmission(quizzes: quizResponse.quizzes)
//                    self.meta = quizResponse.meta
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    fileprivate func presentQuizzes() {
        if self.selectedSegment == 0 {
            self.setOpenedQuizzes()
        } else if self.selectedSegment == 1 {
            self.setOnHoldQuizzes()
        } else {
            self.setClosedQuizzes()
        }
    }
    
    func checkQuizSubmission(quizzes: [FullQuiz]) {
        for quiz in quizzes {
            if quiz.state.elementsEqual("running") {
                if let submission = quiz.studentSubmissions, let startDate = submission.createdAt, !submission.isSubmitted {
                    let now = DateInRegion()
                    let totalTime = (startDate.toDate()!.dateByAdding(quiz.duration, .second))
                    debugPrint(now.toISO(), totalTime.toISO())
                    if  totalTime.isInPast {
                        count += 1
                        var parameters: [String: Any] = [:]
                        parameters["submission"] = ["id": submission.id ?? 0]
                        submitQuiz(parameters: parameters)
                    }
                } else {
                    continue
                }
            }
        }
        if count == 0 {
            presentQuizzes()
        }
    }
    
    func submitQuiz(parameters: Parameters) {
        submitQuizApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.count -= 1
            if isSuccess {
                if self.count == 0 {
                    self.getQuizzes(pageId: self.pageId)
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
}

extension QuizzesViewController: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQuizzes.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "QuizTableViewCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableViewCell") as! QuizTableViewCell
        cell.hideSkeleton()
        cell.quiz = self.filteredQuizzes[indexPath.row]
        if getUserType() != UserType.teacher {
            if indexPath.row >= filteredQuizzes.count - 2 {
//                if meta.totalPages > pageId {
//                    pageId += 1
//                    getQuizzes(pageId: pageId)
//                    if selectedSegment == 0 {
//                        setOpenedQuizzes()
//                    } else if selectedSegment == 2 {
//                        setClosedQuizzes()
//                    } else {
//                        setOnHoldQuizzes()
//                    }
//                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isTeacher {
            //            let quizVC = QuizStatusViewController.instantiate(fromAppStoryboard: .Quizzes)
            //            quizVC.child = self.child
            //            quizVC.courseName = courseName
            //            quizVC.courseGroupId = courseGroupId
            //            quizVC.quiz = filteredQuizzes[indexPath.row]
            //            self.navigationController?.pushViewController(quizVC, animated: true)
            if filteredQuizzes[indexPath.row].state.elementsEqual("finished") {
                getQuizDetails(quizId: filteredQuizzes[indexPath.row].id)
            }
        } else {
            let quizVC = QuizzesGradesViewController.instantiate(fromAppStoryboard: .Quizzes)
            quizVC.quizName = courseName
            quizVC.courseId = courseId
            quizVC.courseGroupId = courseGroupId
            quizVC.quiz = filteredQuizzes[indexPath.row]
            self.navigationController?.pushViewController(quizVC, animated: true)
        }
    }
    
    func getQuizDetails(quizId: Int) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizApi(quizId: quizId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
//                    self.detailedQuiz = DetailedQuiz(result)
                    let quizDetailsVC = QuizDetailsViewController.instantiate(fromAppStoryboard: .Quizzes)
                    quizDetailsVC.quizId = quizId
                    quizDetailsVC.detailedQuiz = DetailedQuiz(result)
                    self.navigationController?.pushViewController(quizDetailsVC, animated: true)
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
}
