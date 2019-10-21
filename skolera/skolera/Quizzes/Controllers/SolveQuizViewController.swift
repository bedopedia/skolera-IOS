//
//  SolveQuizViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/26/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import MobileCoreServices
import NVActivityIndicatorView
import RichTextView

class SolveQuizViewController: UIViewController, NVActivityIndicatorViewable {
    
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
//    var savedDuration = 0
//    var detailedDummyQuiz: DetailedQuiz!
    var detailedQuiz: DetailedQuiz! {
        didSet {
            self.duration = self.detailedQuiz.duration * 60
        }
    }
    var submissionId: Int!
    var currentQuestion = 0
//    Populates the Table view
    var questions: [Any] = []
    var answeredQuestions: [Questions: [Any]]!
    var questionType: QuestionTypes!
    var newOrder: [Answers] = []
    var isQuestionsOnly = false
    var isAnswers = false
    var courseGroupId: Int!
    var duration: Int!
    var previousAnswers: [String : [Any]]!
//    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        answeredQuestions = [:]
        previousAnswers = [:]
//        detailedDummyQuiz = DetailedQuiz.init(dummyResponse2())
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
        timerLabel.text = timeString(time: TimeInterval(duration))
        getAnswers()
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
    //    MARK: - Timer methods
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
            timerLabel.text = timeString(time: TimeInterval(duration))
                if duration < 1 {
                timer.invalidate()
    //            navigateToHome()
            } else {
                duration -= 1
            }
        }
        func timeString(time: TimeInterval) -> String {
            let hours = Int(time) / 3600
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        }
    
//    MARK: - Data setup
    func setUpQuestions() {
        questions = []
        showAnswers()
//        let question = detailedDummyQuiz.questions[currentQuestion]
        let question = detailedQuiz.questions[currentQuestion]
        questionType = question.type.map({ QuestionTypes(rawValue: $0)! })
        if questionType == QuestionTypes.reorder {
            if newOrder.isEmpty {
                newOrder = detailedQuiz.questions[currentQuestion].answers ?? []
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
        if questionType == QuestionTypes.trueOrFalse {
            questions.append("headerCell")
            let correctanswer = Answers.init(["id": question.answers.first?.id as Any ,
                                       "body": "true",
                                       "question_id": question.answers.first?.questionId,
                                       "is_correct": true
                                      ])
            questions.append(correctanswer)
            let falseAnswer = Answers.init(["id": question.answers.first?.id as Any ,
                                         "body": "false",
                                         "question_id": question.answers.first?.questionId,
                                         "is_correct": false
                                       ])
            questions.append(falseAnswer)
        } else {
            if questionType == QuestionTypes.match {
//                should divide the answers and append them all here
                question.answers.first?.options.forEach({ (option) in
                    questions.append(option)
                })
                questions.append("headerCell")
                question.answers.first?.matches.forEach({ (match) in
                    questions.append(match)
                })
                
            } else {
                questions.append("headerCell")
                question.answers?.forEach{ (answer) in
                    questions.append(answer)
                }
            }
        }
        outOfLabel.text = "\(currentQuestion + 1) Out of \(detailedQuiz.questions.count)"
        setTableViewMultipleSelection(question: question)
        if isAnswers {
//            showAnswers()
        }
        tableView.reloadData()
    }
    
    // Add answers in the answered questions dictionary
    func showDummyAnswers() {
        if let answers = detailedQuiz.questions[currentQuestion].answers {
            switch questionType! {
            case .multipleChoice, .multipleSelect:
                answeredQuestions[detailedQuiz.questions[currentQuestion]] = answers.filter({ (answer) -> Bool in
                    guard let correct = answer.isCorrect else {
                        return false
                    }
                    return correct == true
                })
            case .trueOrFalse:
                let correctanswer = Answers.init(["id": detailedQuiz.questions[currentQuestion].answers!.first?.id as Any ,
                                                  "body": "true",
                                                  "created_at": detailedQuiz.questions[currentQuestion].answers?.first?.createdAt,
                                                  "updated_at": detailedQuiz.questions[currentQuestion].answers?.first?.updatedAt,
                                                  "question_id": detailedQuiz.questions[currentQuestion].answers?.first?.questionId,
                                                  "match": detailedQuiz.questions[currentQuestion].answers?.first?.match,
                                                  "deleted_at": detailedQuiz.questions[currentQuestion].answers?.first?.deletedAt,
                                                  "is_correct": detailedQuiz.questions[currentQuestion].answers?.first?.isCorrect
                    ])
                let falseAnswer = Answers.init(["id": detailedQuiz.questions[currentQuestion].answers!.first?.id as Any,
                                                "body": "false",
                                                "created_at": detailedQuiz.questions[currentQuestion].answers?.first?.createdAt,
                                                "updated_at": detailedQuiz.questions[currentQuestion].answers?.first?.updatedAt,
                                                "question_id": detailedQuiz.questions[currentQuestion].answers?.first?.questionId,
                                                "match": detailedQuiz.questions[currentQuestion].answers?.first?.match,
                                                "deleted_at": detailedQuiz.questions[currentQuestion].answers?.first?.deletedAt,
                                                "is_correct": detailedQuiz.questions[currentQuestion].answers?.first?.isCorrect
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
    
    func showAnswers() {
        debugPrint("show answers")
        let questionId  = detailedQuiz.questions[currentQuestion].id!
//        previous answers is an array of objects, search if it contains this question id
        let previousAnswer = previousAnswers.filter { (questionId, answers) -> Bool in
            if questionId.elementsEqual("\(self.detailedQuiz.questions[currentQuestion].id!)") {
                return true
            }
            return false
        }
        debugPrint(previousAnswers)
        if let answersArray = previousAnswer["\(questionId)"] {
            debugPrint(answersArray.count)
            answeredQuestions[detailedQuiz.questions[currentQuestion]] = answersArray
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
    
    func stringValue(booleanValue: Bool) -> String {
        switch booleanValue {
        case true:
            return "true"
        case false:
            return "false"
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
    
//    MARK: - IBActions
    
    @IBAction func backAction() {
        if isQuestionsOnly || isAnswers {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
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
    
//    MARK: - Get Answers
    func getAnswers() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizAnswersSubmissionsApi(submissionId: submissionId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : [Any]] {
//                    array of available answers for the questions
//                    string question id, array of corresponding answers
                    self.previousAnswers = result
                    self.showAnswers()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
}
//MARK: - Table view Extension

extension SolveQuizViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
//    MARK: - cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questions[indexPath.row] is Questions || questions[indexPath.row] is Options {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuizQuestionTableViewCell
            cell.questionType = questionType
            if let question = questions[indexPath.row] as? Questions{
                cell.question = question
                cell.questionBodyView.update(input: question.body)
//                cell.questionBodyView.update(input: "<img width = 50, height = 50, src=\"https://upload.wikimedia.org/wikipedia/commons/f/f9/Phoenicopterus_ruber_in_S%C3%A3o_Paulo_Zoo.jpg\"> <p>This is normal text - <b>and this is bold text</b>.</p> <img src = \"http://via.placeholder.com/70\">")
                
            } else {
                if let option = questions[indexPath.row] as? Options {
                    cell.option = option
                    cell.questionBodyView.update(input: option.body)
                    cell.matchIndex = indexPath.row
                }
            }
            return cell
        } else {
            if let title = questions[indexPath.row] as? String, title.elementsEqual("headerCell") {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerLabelCell") as! QuizAnswerLabelTableViewCell
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
                if let question = questions.first as? Questions {
                    cell.questionType = question.type.map { QuestionTypes(rawValue: $0) }!
                }
                if isAnswers {
                    cell.isAnswers = true
                }
                switch questionType! {
                case .match:
                    cell.matchString = questions[indexPath.row] as? String
                case .reorder:
                    if !newOrder.isEmpty {
                        cell.answer = newOrder[indexPath.row - 2]
                    }
                default:
                    if let selectedAnswer = questions[indexPath.row] as? Answers {
                        if let answers = answeredQuestions[detailedQuiz.questions[currentQuestion]] {
                            for answer in answers {
                                if let modelledAnswer = answer as? Answers {
//                                    in case of using the answers api
                                    if isAnswers && questionType! == .trueOrFalse {
                                        if (selectedAnswer.body?.elementsEqual(stringValue(booleanValue: selectedAnswer.isCorrect!)))! {
                                            cell.setSelectedImage()
                                        }
                                    } else {
                                        if modelledAnswer.id == selectedAnswer.id, modelledAnswer.body == selectedAnswer.body {
                                            cell.setSelectedImage()
                                        }
                                    }
                                } else {
//                                    answers from get submissions api
                                    if let answerDict = answer as? [String: Any] {
                                        if questionType == QuestionTypes.trueOrFalse {
                                            if let trueOrFalse = answerDict["is_correct"] as? Bool{
                                                if trueOrFalse == selectedAnswer.isCorrect! {
                                                    cell.setSelectedImage()
                                                }
                                            }
                                        } else {
//                                            handle multiselect, multiple choices
                                            if let trueOrFalse = answerDict["is_correct"] as? Bool, trueOrFalse == true {
                                                if let answerId = answerDict["answer_id"] as? Int, answerId == selectedAnswer.id! {
                                                    cell.setSelectedImage()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        cell.answer = questions[indexPath.row] as? Answers
                    }
                }
                if isAnswers || isQuestionsOnly {
                    cell.matchTextField.isUserInteractionEnabled = false
                }
                return cell
            }
        }
    }
    
//    MARK: - didSelectRow
    
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
//    MARK: - Drag and Drop methods
    
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
