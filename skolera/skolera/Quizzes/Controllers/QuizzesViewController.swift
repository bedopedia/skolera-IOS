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
        if isParent() {
            statusSegmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
        } else {
            if isTeacher {
                statusSegmentControl.tintColor = #colorLiteral(red: 0, green: 0.4959938526, blue: 0.8980392157, alpha: 1)
            } else {
                statusSegmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
            }
        }
        if isTeacher {
            getTeacherQuizzes()
        } else {
            getQuizzes(pageId: pageId)
        }
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
                    self.setOpenedQuizzes()
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
                        self.meta = quizResponse.meta
                        self.setOpenedQuizzes()
                    } else {
                        self.quizzes.append(contentsOf: quizResponse.quizzes)
                    }
                }
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
        if indexPath.row >= filteredQuizzes.count - 2 {
//            debugPrint("Index path: ",indexPath.row)
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
            quizVC.quiz = filteredQuizzes[indexPath.row]
            quizVC.courseGroupId = self.courseId
            self.navigationController?.pushViewController(quizVC, animated: true)
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
