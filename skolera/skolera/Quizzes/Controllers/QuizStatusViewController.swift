//
//  QuizStatusViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class QuizStatusViewController: UIViewController {
   
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
    var child : Child!
    var courseName: String = ""
    var courseGroupId: Int!
    var detailedQuiz: DetailedQuiz!
    var solvingQuiz = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        detailsImage.image = #imageLiteral(resourceName: "chevronRight").flipIfNeeded()
        questionsImage.image = #imageLiteral(resourceName: "chevronRight").flipIfNeeded()
        answersImage.image = #imageLiteral(resourceName: "chevronRight").flipIfNeeded()
        titleLabel.text = courseName
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
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
//        getQuizDetails()
    }
    
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
//        quizDetailsVC.detailedQuiz = self.detailedQuiz
        self.navigationController?.pushViewController(quizDetailsVC, animated: true)
    }
    
    @IBAction func solveQuizButtonAction() {
//        createSubmission()
        solvingQuiz = true  //should be removed, already in createSubmission
        let solveQuizVC = SolveQuizViewController.instantiate(fromAppStoryboard: .Quizzes)
        self.navigationController?.pushViewController(solveQuizVC, animated: true)
    }
    @IBAction func openQuizQuestions() {
        let solveQuizVC = SolveQuizViewController.instantiate(fromAppStoryboard: .Quizzes)
        solveQuizVC.isQuestionsOnly = true
        self.navigationController?.pushViewController(solveQuizVC, animated: true)
    }
    @IBAction func openQuizAnswers() {
        let solveQuizVC = SolveQuizViewController.instantiate(fromAppStoryboard: .Quizzes)
        solveQuizVC.isAnswers = true
        self.navigationController?.pushViewController(solveQuizVC, animated: true)
    }
    
    func createSubmission() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = ["submission" : ["quiz_id": quiz.id!, "student_id": child.actableId!, "course_group_id": courseGroupId, "score": 0 ]]
        createSubmissionApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                let solveQuizVC = SolveQuizViewController.instantiate(fromAppStoryboard: .Quizzes)
                self.solvingQuiz = true
                self.navigationController?.pushViewController(solveQuizVC, animated: true)
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
//    func getQuizDetails() {
//        SVProgressHUD.show(withStatus: "Loading".localized)
//        getQuizApi(quizId: quiz.id!) { (isSuccess, statusCode, value, error) in
//            SVProgressHUD.dismiss()
//            if isSuccess {
//                if let result = value as? [String : AnyObject] {
//                    self.detailedQuiz = DetailedQuiz(result)
//                }
//            } else {
//                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
//            }
//        }
//    }
    
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
        
        if let _ = quiz.studentSubmissions.id {
            solveQuizButton.isHidden = true
            quizDateLabel.text = "Solved".localized
            quizTotalGradeLabel.text = Language.language == .arabic ? "من \(quiz.totalScore ?? 0)" :  "Out of \(quiz.totalScore ?? 0)"
            //                studentFinishedQuizView.isHidden = false
        } else {
            studentFinishedQuizView.isHidden = true
            solveQuizButton.isHidden = false
            if !getUserType().elementsEqual("student") {
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
        quizClockImage.image = #imageLiteral(resourceName: "1")
        notStartedQuizView.isHidden = true
        studentFinishedQuizView.isHidden = false
        solveQuizButton.isHidden = true
        if let _ = quiz.studentSubmissions.id {
            quizTotalGradeLabel.text = Language.language == .arabic ? "من \(quiz.totalScore ?? 0)" :  "Out of \(quiz.totalScore ?? 0)"
            gradeView.isHidden = false
            quizDateLabel.text = "Solved".localized
        } else {
            gradeView.isHidden = true
            if !getUserType().elementsEqual("student") {
                notStartedQuizView.isHidden = false
            }
        }
        if getUserType().elementsEqual("parent") {
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
