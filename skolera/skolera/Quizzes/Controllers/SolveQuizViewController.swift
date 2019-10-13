//
//  SolveQuizViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/26/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import MobileCoreServices

class SolveQuizViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var outOfLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet var outOfLabelHeight: NSLayoutConstraint!
    @IBOutlet var timerLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var backButtonAllignment: NSLayoutConstraint!
    
    var timer = Timer()
    var isTimerRunning = false
    var savedDuration = 0
    var detailedQuiz: DetailedQuiz!
    var currentQuestion = 0
    var questions: [Any] = []
    var answeredQuestions: [Questions: [Any]]!
    var questionType: QuestionTypes!
    var newOrder: [Answers] = []
    var isQuestionsOnly = false
    var isAnswers = false
    var duration = 60 {
        didSet{
            timerLabel.text = timeString(time: TimeInterval(duration))
        }
    }
    
    // Add answers in the answered questions dictionary
    func showAnswers() {
        if let answers = detailedQuiz.questions[currentQuestion].answersAttributes {
            switch questionType! {
            case .multipleChoice, .multipleSelect:
                answeredQuestions[detailedQuiz.questions[currentQuestion]] = answers.filter({ (answer) -> Bool in
                    guard let correct = answer.isCorrect else {
                        return false
                    }
                    return correct == true
                })
            case .trueOrFalse:
                let correctanswer = Answers.init(["id": detailedQuiz.questions[currentQuestion].answersAttributes!.first?.id as Any ,
                                                  "body": "true",
                                                  "created_at": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.createdAt,
                                                  "updated_at": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.updatedAt,
                                                  "question_id": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.questionId,
                                                  "match": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.match,
                                                  "deleted_at": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.deletedAt,
                                                  "is_correct": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.isCorrect
                    ])
                let falseAnswer = Answers.init(["id": detailedQuiz.questions[currentQuestion].answersAttributes!.first?.id as Any,
                                                "body": "false",
                                                "created_at": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.createdAt,
                                                "updated_at": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.updatedAt,
                                                "question_id": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.questionId,
                                                "match": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.match,
                                                "deleted_at": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.deletedAt,
                                                "is_correct": detailedQuiz.questions[currentQuestion].answersAttributes?.first?.isCorrect
                    ])
                answeredQuestions[detailedQuiz.questions[currentQuestion]] = [correctanswer, falseAnswer]
            default:
                answeredQuestions[detailedQuiz.questions[currentQuestion]] = answers.sorted(by: { (firstAnswer, secondAnswer) -> Bool in
                    guard let firstMatch = Int(firstAnswer.match ?? ""), let secondMatch = Int(secondAnswer.match ?? "") else {
                        return false
                    }
                    return firstMatch < secondMatch
                })
                newOrder = answeredQuestions[detailedQuiz.questions[currentQuestion]] as! [Answers]
            }
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        answeredQuestions = [:]
        detailedQuiz = DetailedQuiz.init(dummyResponse2())
        setUpQuestions()
        NSLayoutConstraint.deactivate([outOfLabelHeight])
        previousButtonAction()
        if isQuestionsOnly || isAnswers {
            timerLabel.isHidden = true
            tableView.allowsSelection = false
            NSLayoutConstraint.deactivate([timerLabelTopConstraint])
            backButtonAllignment.constant = 0
            headerHeightConstraint.constant = 60
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isTimerRunning {
            runTimer()
        }
        NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: nil) { (notification) in
            debugPrint("Background mode")
            UserDefaults.standard.set(Date().second, forKey: "timerDuration")
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { (notification) in
            if let timerDuration = UserDefaults.standard.string(forKey: "timerDuration") {
                self.duration -= ( Date().second - Int(timerDuration)! )
                debugPrint("Background time is:", Date().second - Int(timerDuration)!)
            }
        }
    }
    
    @IBAction func backAction() {
        if isQuestionsOnly || isAnswers {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(self.updateTimer)),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        timer.tolerance = 0.1
    }
    
    @objc func updateTimer() {
            if duration < 1 {
            timer.invalidate()
//            navigateToHome()
        } else {
            duration -= 1
        }
    }
    
    func navigateToHome() {
        let submitQuiz = QuizSubmissionViewController.instantiate(fromAppStoryboard: .Quizzes)
        submitQuiz.openQuizStatus = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        submitQuiz.modalPresentationStyle = .fullScreen
        self.navigationController?.navigationController?.present(submitQuiz, animated: true, completion: nil)
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func stringValue(booleanValue: Bool) -> String {
        switch booleanValue {
        case true:
            return "true"
        case false:
            return "false"
        }
    }
    
    @IBAction func nextButtonAction() {
        if currentQuestion < detailedQuiz.questions.count - 1 {
            currentQuestion += 1
            setUpQuestions()
        } else {
//            TODO: call the submit grade api, call back action
            debugPrint("submit grade")
        }
        if let _ = outOfLabelHeight {
            NSLayoutConstraint.deactivate([outOfLabelHeight])
        }
        outOfLabel.isHidden = false
        previousButton.setTitle("Previous", for: .normal)
        
        if currentQuestion == detailedQuiz.questions.count - 1 {
            if isQuestionsOnly || isAnswers {
                NSLayoutConstraint.activate([outOfLabelHeight])
                outOfLabel.isHidden = true
                nextButton.backgroundColor = .clear
                nextButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                nextButton.setTitle("\(currentQuestion + 1) out of \(detailedQuiz.questions.count)", for: .normal)
            } else {
                nextButton.setTitle("Submit", for: .normal)
            }
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        self.view.layoutIfNeeded()
    }
    
    @IBAction func previousButtonAction() {
        
        if currentQuestion == detailedQuiz.questions.count - 1, isQuestionsOnly || isAnswers {
            NSLayoutConstraint.deactivate([outOfLabelHeight])
            outOfLabel.isHidden = false
            outOfLabel.text = "\(currentQuestion + 1) Out of \(detailedQuiz.questions.count)"
            nextButton.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.5098039216, blue: 0.4078431373, alpha: 1)
            nextButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        }
        if currentQuestion > 0 {
            currentQuestion -= 1
            setUpQuestions()
        }
        if currentQuestion == 0 {
            outOfLabel.isHidden = true
            NSLayoutConstraint.activate([outOfLabelHeight])
            previousButton.setTitle("1 Out of \(detailedQuiz.questions.count)", for: .normal)
        }
        if currentQuestion < detailedQuiz.questions.count - 1 {
            nextButton.setTitle("Next", for: .normal)
        }
        self.view.layoutIfNeeded()
    }
    
    func setUpQuestions() {
        questions = []
        let question = detailedQuiz.questions[currentQuestion]
        questionType = question.type.map({ QuestionTypes(rawValue: $0)! })
        if questionType == QuestionTypes.reorder {
            if newOrder.isEmpty {
                newOrder = detailedQuiz.questions[currentQuestion].answersAttributes ?? []
            }
            //questions array should have the state saved
            if !isQuestionsOnly && !isAnswers {
                tableView.dragInteractionEnabled = true
            }
        } else {
            tableView.dragInteractionEnabled = false
        }
        questions.append(question)
        //      TO:DO  check is th question type is match and append the match model
        questions.append("Answers")
        
        if questionType == QuestionTypes.trueOrFalse {
            let correctanswer = Answers.init(["id": question.answersAttributes!.first?.id as Any ,
                                       "body": "true",
                                       "created_at": question.answersAttributes?.first?.createdAt,
                                      "updated_at": question.answersAttributes?.first?.updatedAt,
                                      "question_id": question.answersAttributes?.first?.questionId,
                                      "match": question.answersAttributes?.first?.match,
                                      "deleted_at": question.answersAttributes?.first?.deletedAt,
                                      "is_correct": question.answersAttributes?.first?.isCorrect
                                      ])
            questions.append(correctanswer)
            let falseAnswer = Answers.init(["id": question.answersAttributes!.first?.id as Any,
                                              "body": "false",
                                              "created_at": question.answersAttributes?.first?.createdAt,
                                              "updated_at": question.answersAttributes?.first?.updatedAt,
                                              "question_id": question.answersAttributes?.first?.questionId,
                                              "match": question.answersAttributes?.first?.match,
                                              "deleted_at": question.answersAttributes?.first?.deletedAt,
                                              "is_correct": question.answersAttributes?.first?.isCorrect
                ])
            questions.append(falseAnswer)
        } else {
            question.answersAttributes?.forEach{ (answer) in
                questions.append(answer)
            }
        }
        outOfLabel.text = "\(currentQuestion + 1) Out of \(detailedQuiz.questions.count)"
        setTableViewMultipleSelection(question: question)
        if isAnswers {
            showAnswers()
        }
        tableView.reloadData()
    }
    
    func setTableViewMultipleSelection(question: Questions) {
        if let questionType = question.type.map({ QuestionTypes(rawValue: $0) }) {
            if questionType == QuestionTypes.multipleSelect {
                if !isQuestionsOnly && !isAnswers {
                    self.tableView.allowsMultipleSelection = true
                }
            } else {
                self.tableView.allowsMultipleSelection = false
            }
        }
    }

}

extension SolveQuizViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questions[indexPath.row] is Questions {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuizQuestionTableViewCell
            cell.question = questions[indexPath.row] as? Questions
            if let _ = questions.first as? Questions {
                cell.questionType = questionType
            }
            return cell
        } else {
            if questions[indexPath.row] is String {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerLabelCell") as! QuizAnswerLabelTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
                if let question = questions.first as? Questions {
                    cell.questionType = question.type.map { QuestionTypes(rawValue: $0) }!
                }
                if isAnswers {
                    cell.isAnswers = true
                }
                switch questionType! {
//                case .match:
                case .reorder:
                    if !newOrder.isEmpty {
                        cell.answer = newOrder[indexPath.row - 2]
                    }
                default:
                    if let selectedAnswer = questions[indexPath.row] as? Answers {
                        if let answers = answeredQuestions[detailedQuiz.questions[currentQuestion]] {
                            for answer in answers {
                                if let modelledAnswer = answer as? Answers {
                                    if isAnswers && questionType! == .trueOrFalse {
                                        if (selectedAnswer.body?.elementsEqual(stringValue(booleanValue: selectedAnswer.isCorrect!)))! {
                                            cell.setSelectedImage()
                                        }
                                    } else {
                                        if modelledAnswer.id == selectedAnswer.id, modelledAnswer.body == selectedAnswer.body {
                                            cell.setSelectedImage()
                                        }
                                    }
                                }
                            }
                        }
                    }
                    cell.answer = questions[indexPath.row] as? Answers
                }
                if isAnswers || isQuestionsOnly {
                    cell.matchTextField.isUserInteractionEnabled = false
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? QuizAnswerTableViewCell
        if let type = questionType, type == QuestionTypes.match {
            cell?.matchTextField.becomeFirstResponder()
            return
        } else {
            cell?.matchTextField.resignFirstResponder()
        }
        //should save the answer for this question
        switch questionType! {
        case .multipleChoice, .multipleSelect, .trueOrFalse:
            if var previousAnswers = answeredQuestions[detailedQuiz.questions[currentQuestion]], questionType == QuestionTypes.multipleSelect {
                //check that the current selection doesn't exist in the answers array
                var flag: Bool = true
                var answerToBeRemovedIndex: Int!
                if let selectedAnswer = questions[indexPath.row] as? Answers {
                    for (index, answer) in previousAnswers.enumerated() {
                        if flag == true {
                            if let validAnswer = answer as? Answers {
                                if validAnswer.id == selectedAnswer.id {
                                    answerToBeRemovedIndex = index
                                    flag = false
                                    break
                                }
                            }
                        }
                    }
                    if flag {
                        previousAnswers.append(selectedAnswer)
                        answeredQuestions[detailedQuiz.questions[currentQuestion]] = previousAnswers
                    } else {
                        //remove the selected answer from the array and reload the table
                        if answerToBeRemovedIndex != nil {
                            previousAnswers.remove(at: answerToBeRemovedIndex)
                            answeredQuestions[detailedQuiz.questions[currentQuestion]] = previousAnswers
                            tableView.reloadData()
                        }
                    }
                }
            } else {
                if let validAnswer = questions[indexPath.row] as? Answers {
                    answeredQuestions[detailedQuiz.questions[ currentQuestion] ] = [validAnswer]
                }
            }
            tableView.reloadData()
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if let destIndex = destinationIndexPath, destIndex.row < 2 {
            return UITableViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
        var oldIndex: Int!
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        //        drop destination is below the questions and the answer cell.
        guard destinationIndexPath.row > 1 else {
            return
        }
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let answerBody = (items as? [String])?.first else { return }
            for (index, anyAnswer) in self.questions.enumerated() {
                if let answer = anyAnswer as? Answers {
                    if answer.body!.elementsEqual(answerBody) {
                        oldIndex = index
                    }
                }
            }
            if oldIndex == nil {
                return
            }
            let newIndex = destinationIndexPath.row
            self.newOrder.swapAt(oldIndex - 2, newIndex - 2)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        //should be disabled for questions and the answer cell
        if indexPath.row < 2 {
            return []
        } else {
            // 2 for the uppermost 2 cells
            var string = ""
            if let answer = questions[indexPath.row] as? Answers {
                string = answer.body!
            }
            guard let data = string.data(using: .utf8) else { return [] }
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
            return [UIDragItem(itemProvider: itemProvider)]
        }
    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row < 2 {
//            return false
//        }
//        return true
//    }
    
}
