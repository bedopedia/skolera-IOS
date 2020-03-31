//
//  QuizStatusViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class QuizStatusViewController: UIViewController, NVActivityIndicatorViewable {
   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var dueMonthLabel: UILabel!
    @IBOutlet weak var quizDateView: UIView!
    @IBOutlet weak var quizClockImage: UIImageView!
    @IBOutlet weak var quizDateLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var notStartedQuizView: UIView!
    @IBOutlet weak var studentFinishedQuizView: UIView!
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var quizGradeLabel: UILabel!
    @IBOutlet weak var quizTotalGradeLabel: UILabel!
    @IBOutlet weak var quizNoteLabel: UILabel!
    @IBOutlet weak var solveQuizButton: UIButton!
    @IBOutlet weak var detailsImage: UIImageView!
    @IBOutlet weak var questionsImage: UIImageView!
    @IBOutlet weak var answersImage: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var questionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answersHeightConstraint: NSLayoutConstraint!
    
    var quiz: FullQuiz!
    var child : Actor!
    var courseName: String = ""
    var courseGroupId: Int!
    var detailedQuiz: DetailedQuiz!
    var solvingQuiz = false
    var submission: Submission!
    var submissionId: Int!
    var isSolvable = true
    var correctAnswer = true
    var isAnswers = false
    var submissionDate: String!

    
//    MARK: -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        detailsImage.image = #imageLiteral(resourceName: "chevronRight").flipIfNeeded()
        questionsImage.image = #imageLiteral(resourceName: "chevronRight").flipIfNeeded()
        answersImage.image = #imageLiteral(resourceName: "chevronRight").flipIfNeeded()
        titleLabel.text = courseName
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first ?? Character(" "))\(child.lastname.first ?? Character(" "))", textSize: 14)
        }
        nameLabel.text = quiz.name
        courseNameLabel.text = courseName
        setUpDatesUi()
        setUpGradeUi()
        if quiz.state.elementsEqual("running") {
            setUpRunningQuizUi()
        } else {
            setUpFinishedQuizUi()
        }
    }
//    MARK: - Create Submission
    
    func createSubmission() {
            startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
            let parameters : Parameters = ["submission" : ["quiz_id": quiz.id!, "student_id": child.childId!, "course_group_id": courseGroupId, "score": 0, "is_submitted": false]]
            createSubmissionApi(parameters: parameters) { (isSuccess, statusCode, response, error) in
                if isSuccess {
                    if let result = response as? [String : AnyObject] {
                        self.submission = Submission(result)
                        self.submissionId = self.submission.id
                        self.submissionDate = self.submission.createdAt
                    }
                    if statusCode == 422 {
                        debugPrint(self.quiz.studentSubmissions)
                    }
                    self.getSolveQuizDetails()
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        }
    //    MARK: - Get solve quiz details
        
    func getSolveQuizDetails() {
        getQuizSolveDetailsApi(quizId: self.quiz.id!) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    self.detailedQuiz = DetailedQuiz(result)
                }
                self.solvingQuiz = true  //should be removed, already in createSubmission
                let solveQuizVC = SolveQuizViewController.instantiate(fromAppStoryboard: .Quizzes)
                solveQuizVC.courseGroupId = self.courseGroupId
                solveQuizVC.isSolvable = self.isSolvable
                solveQuizVC.detailedQuiz = self.detailedQuiz
                solveQuizVC.submissionId = self.submissionId
                solveQuizVC.submissionDate = self.submissionDate
                solveQuizVC.showCorrectAnswer = self.correctAnswer
                self.navigationController?.pushViewController(solveQuizVC, animated: true)
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
//    MARK: - IBActions
    @IBAction func back() {
            if solvingQuiz {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    @IBAction func openQuizDetails() {
        let quizDetailsVC = QuizDetailsViewController.instantiate(fromAppStoryboard: .Quizzes)
        quizDetailsVC.quizId = quiz.id
        self.navigationController?.pushViewController(quizDetailsVC, animated: true)
    }
    
    @IBAction func solveQuizButtonAction() {
        self.isSolvable = true
        self.correctAnswer = false
        if let submissionId = quiz.studentSubmissions.id {
            self.startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
            self.submissionId = submissionId
            self.submissionDate = quiz.studentSubmissions.createdAt
            getSolveQuizDetails()
        } else {
            createSubmission()
        }
    }
    
    @IBAction func openQuizQuestions() {
        self.correctAnswer = false
        if quiz.state.elementsEqual("finished") {
            self.isSolvable = false
            getQuizDetails()
        } else {
            self.isSolvable = false
            if quiz.studentSubmissions.isSubmitted {
                getQuizDetails()
            } else {
                getSolveQuizDetails()
            }
        }
        
    }
    
    func getQuizDetails() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizApi(quizId: self.quiz.id!) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    self.detailedQuiz = DetailedQuiz(result)
                    let solveQuizVC = SolveQuizViewController.instantiate(fromAppStoryboard: .Quizzes)
                    solveQuizVC.isQuestionsOnly = true
                    solveQuizVC.detailedQuiz = self.detailedQuiz
                    solveQuizVC.isSolvable = self.isSolvable
                    solveQuizVC.showCorrectAnswer = self.correctAnswer
                    solveQuizVC.submissionId = self.quiz.studentSubmissions.id
                    solveQuizVC.isAnswers = self.isAnswers
                    solveQuizVC.isQuestionsOnly = !self.isAnswers
                    self.navigationController?.pushViewController(solveQuizVC, animated: true)
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    @IBAction func openQuizAnswers() {
        self.isAnswers = true
        self.correctAnswer = false
        if quiz.state.elementsEqual("finished") {
            self.isSolvable = false
            self.correctAnswer = true
            getQuizDetails()
        } else {
            self.isSolvable = false
            if quiz.studentSubmissions.isSubmitted {
                getQuizDetails()   // show quiz
            } else {
                getSolveQuizDetails()
            }
        }
    }
//    MARK: - UI Setup
    func setUpDatesUi() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        let quizDate = dateFormatter.date(from: quiz.startDate)
        let endDate = dateFormatter.date(from: quiz.endDate)
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "dd MMM YYYY"
        if Language.language == .arabic {
            publishDateLabel.text = "نشر " + newDateFormat.string(from: quizDate!)
        } else {
            publishDateLabel.text = "publish \(newDateFormat.string(from: quizDate!))"
        }
        newDateFormat.dateFormat = "dd"
        dueDayLabel.text = newDateFormat.string(from: endDate!)
        newDateFormat.dateFormat = "MMM"
        dueMonthLabel.text = newDateFormat.string(from: endDate!)
        if let quizStringDate = quiz.endDate {
            quizDateView.isHidden = false
            quizDateLabel.isHidden = false
            quizClockImage.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
            
            let quizDate = dateFormatter.date(from: quizStringDate)
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
            quizDateLabel.text = newDateFormat.string(from: quizDate!)
            
        } else {
            quizDateView.isHidden = true
            quizDateLabel.isHidden = true
            quizClockImage.isHidden = true
        }
    }
    
    func setUpGradeUi() {
        if let grade = quiz.studentSubmissions.score {
            quizGradeLabel.text = "\(grade)"
            if let note = quiz.studentSubmissions.feedback{
                quizNoteLabel.text = "\(note)"
            } else {
                quizNoteLabel.text = ""
            }
        } else {
            quizGradeLabel.text = "--"
            quizNoteLabel.text = "Not graded yet".localized
        }
    }
    
    func setUpRunningQuizUi() {
        quizDateView.backgroundColor = #colorLiteral(red: 0.8247086406, green: 0.9359105229, blue: 0.8034248352, alpha: 1)
        quizDateLabel.textColor = #colorLiteral(red: 0.1179271713, green: 0.2293994129, blue: 0.09987530857, alpha: 1)
        quizClockImage.image = #imageLiteral(resourceName: "greenHour")
        //check the availability of a submission
        if let submission = quiz.studentSubmissions, submission.isSubmitted == true {
            solveQuizButton.isHidden = true
            quizDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
            quizDateLabel.textColor = #colorLiteral(red: 0.4231846929, green: 0.243329376, blue: 0.1568627451, alpha: 1)
            quizClockImage.image = nil
            quizDateLabel.text = "Solved".localized
            quizTotalGradeLabel.text = Language.language == .arabic ? "من \(quiz.totalScore ?? 0)" :  "Out of \(quiz.totalScore ?? 0)"
        } else {
            studentFinishedQuizView.isHidden = true
            solveQuizButton.isHidden = false
            if getUserType() != UserType.student {
                notStartedQuizView.isHidden = false
            } else {
                notStartedQuizView.isHidden = true
            }
        }
    }
    
    func setUpFinishedQuizUi() {
        solveQuizButton.isHidden = true
        quizDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
        quizDateLabel.textColor = #colorLiteral(red: 0.4231846929, green: 0.243329376, blue: 0.1568627451, alpha: 1)
        quizClockImage.image = nil
        notStartedQuizView.isHidden = true
        studentFinishedQuizView.isHidden = false
        solveQuizButton.isHidden = true
        if let _ = quiz.studentSubmissions.id {
            quizTotalGradeLabel.text = Language.language == .arabic ? "من \(quiz.totalScore ?? 0)" :  "Out of \(quiz.totalScore ?? 0)"
            gradeView.isHidden = false
            quizDateLabel.text = "Solved".localized
        } else {
            gradeView.isHidden = true
            if getUserType() != UserType.student {
                notStartedQuizView.isHidden = false
            }
        }
        if getUserType() == UserType.parent {
            //constraints = 0, isHidden = true
            answersHeightConstraint.constant = 0
            questionsHeightConstraint.constant = 0
            detailsHeightConstraint.constant = 0
            detailsView.isHidden = true
        }
        if quiz.studentSubmissions != nil {
//            quizDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
//            quizDateLabel.textColor = #colorLiteral(red: 0.4231846929, green: 0.243329376, blue: 0.1568627451, alpha: 1)
            quizClockImage.image = nil
        } else {
            gradeView.isHidden = true
        }
    }

}
