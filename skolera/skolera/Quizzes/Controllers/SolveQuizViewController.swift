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
            if isSolvable {
                self.duration = self.detailedQuiz.duration * 60
            }
            self.questions = self.detailedQuiz.questions
        }
    }
    var submissionId: Int!
    var currentQuestion = 0
    //    Populates the Table view
    var tableViewDataSourceArray: [Any] = []
    var questions: [Questions] = []
    var prevAnswers: [Int : Set<Answer>] = [:]
    var studentAnswers: [Int : Set<Answer>] = [:]
    var newOrder: [Answer] = []
    var isQuestionsOnly = false
    var isAnswers = false
    var isSolvable = true
    var courseGroupId: Int!
    var duration: Int!
    
    var matchesMap: [String: Option]!
    var deletionFlag = false
    var options: [Option] = []
    var showCorrectAnswer = true
    
    //    MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dropDelegate = self
        tableView.dragDelegate = self
        questions = []
        prevAnswers = [:]
        matchesMap = [:]
        NSLayoutConstraint.deactivate([outOfLabelHeight])
        previousButtonAction()
        if isQuestionsOnly || isAnswers {
            timerLabel.isHidden = true
            tableView.allowsSelection = false
            NSLayoutConstraint.deactivate([timerLabelTopConstraint])
            backButtonAllignment.constant = 0
            headerHeightConstraint.constant = 60
            setUpQuestions()
        }
        if !showCorrectAnswer {
            getAnswers()
        }
        timerLabel.text = timeString(time: TimeInterval(duration))
        headerTitle.text = detailedQuiz.name ?? ""
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
    
//    MARK: - Setup Reorder question
    func sortReorderQuestion() {
        guard let answers = questions[currentQuestion].answers else {
            return
        }
        let questionId = detailedQuiz.questions[currentQuestion].id
        if isAnswers {
            if showCorrectAnswer {
                newOrder = answers.sorted(by: { (answer1, answer2) -> Bool in
                    answer1.match < answer2.match
                })
            } else {
                newOrder = answers
            }
        } else {
            if let orderAnswers = prevAnswers[questionId ?? 0] {
                let orderedAnswers = orderAnswers.sorted { (answer1, answer2) -> Bool in
                    guard let first = answer1.match, let second = answer2.match  else {
                            return false
                    }
                    return first < second
                }
                newOrder = orderedAnswers
            } else {
                if newOrder.isEmpty {
                    newOrder = answers
                }
            }
        }
    }
    
    //    MARK: - Data setup
    fileprivate func generateOptions(_ question: Questions, shouldAppendOption: Bool = true) {
        question.answers.forEach({ (matchAnswer) in
            let option = Option.init(["id":matchAnswer.id!,
                                      "question_id":question.id!,
                                      "body": matchAnswer.body!])
            tableViewDataSourceArray.append(option)
            options.append(option)
            if showCorrectAnswer {
                matchesMap[matchAnswer.match!] = option
            }
        })
    }
    
    func setUpQuestions() {
        if self.deletionFlag {
            self.deletionFlag = false
            getAnswers()
        } else {
            let question = questions[currentQuestion]
            tableViewDataSourceArray = []
            if !isQuestionsOnly && !isAnswers {
                tableView.dragInteractionEnabled = true
            } else {
                tableView.dragInteractionEnabled = false
            }
            tableViewDataSourceArray.append(question)
            
            if question.type == .reorder {
                sortReorderQuestion()
            }
            if question.type == .match {
                if isAnswers || isQuestionsOnly {
                    options = []
                    generateOptions(question)
                    tableViewDataSourceArray.append("headerCell")
                    question.answers.forEach({ (matchAnswer) in
                        tableViewDataSourceArray.append(matchAnswer.match)
                    })
                } else {
                    question.answers.first?.options.forEach({ (option) in
                        tableViewDataSourceArray.append(option)
                    })
                    tableViewDataSourceArray.append("headerCell")
                    question.answers.first?.matches.forEach({ (match) in
                        tableViewDataSourceArray.append(match)
                    })
                }
            } else {    //mc ans ms
                tableViewDataSourceArray.append("headerCell")
                question.answers?.forEach{ (answer) in
                    tableViewDataSourceArray.append(answer)
                }
                setTableViewMultipleSelection(question: question)
            }
            outOfLabel.text = "\(currentQuestion + 1) Out of \(detailedQuiz.questions.count)"
            tableView.reloadData()
        }
    }
    
//    MARK: - Set Multi-selection
    func setTableViewMultipleSelection(question: Questions) {
        if question.type == .multipleSelect {
            if !isQuestionsOnly && !isAnswers {
                self.tableView.allowsMultipleSelection = true
            }
        } else {
            self.tableView.allowsMultipleSelection = false
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
//    MARK: - Handle match answers
    
    func matchAnswers(matchIndex: String!, matchString: String) {
        if matchIndex.isEmpty {
            if let _ = matchesMap[matchString] {
                matchesMap.removeValue(forKey: matchString)
            }
        } else {
            if let arrayIndex = Int(matchIndex ?? ""), arrayIndex < options.count {
                let option = options[arrayIndex - 1]
                for match in matchesMap {
                    if match.value == option {
                        matchesMap.removeValue(forKey: match.key)
                    }
                }
                matchesMap[matchString] = option
            } else {
                return
            }
        }
        self.tableView.reloadData()
    }
    
//    MARK: - Should Skip Submission
    func shouldSkipSubmission() -> Bool {
        if let questionType = questions[currentQuestion].type {
            switch questionType {
            case .multipleSelect, .multipleChoice:
                let studentAnswersIdsSet = self.studentAnswers[questions[currentQuestion].id!]?.filter({$0.isCorrect})
                let studentAnswersIdsArray = studentAnswersIdsSet?.map({ $0.id! }) ?? []
                let prevAnswersIdsSet = self.prevAnswers[questions[currentQuestion].id!]?.filter({$0.isCorrect})
                let prevAnswersIdsArray = prevAnswersIdsSet?.map({$0.id!}) ?? []
                return studentAnswersIdsArray.containsSameElements(as: prevAnswersIdsArray)
            case .match:
                var shouldSkipSubmission = true
                var studentMatchAnswers: [String: Int] = [:]
                var previousMatchAnswers: [String: Int] = [:]
                for matchTuple in matchesMap {
                    studentMatchAnswers[matchTuple.key] = matchTuple.value.id!
                }
                for previousAnswer in questions[currentQuestion].answers {
                    previousMatchAnswers[previousAnswer.match!] = previousAnswer.id!
                }
                shouldSkipSubmission = NSDictionary(dictionary: studentMatchAnswers).isEqual(to: NSDictionary(dictionary: previousMatchAnswers) as! [AnyHashable : Any])
                return shouldSkipSubmission
            case .reorder:
                var shouldSkipSubmission = true
                if let previousAnswers = questions[currentQuestion].answers {
                    for studentAnswer in studentAnswers[questions[currentQuestion].id!]! {
                        let tempPreviousAnswer = previousAnswers.first { (answer) -> Bool in
                            answer.id == studentAnswer.id
                        }
                        if let prevAnswer = tempPreviousAnswer, !prevAnswer.match.elementsEqual(studentAnswer.match!) {
                            shouldSkipSubmission = false
                            break
                        }
                    }
                    return shouldSkipSubmission
                } else {
                    return false
                }
            }
        }
        return true
    }
    
//    MARK: - Create answers dictionary
    func createAnswersDictionary() -> [String: Any] {
        let question = questions[currentQuestion]
        guard let questionType = question.type else {
            return [:]
        }
        var parameters: [String: Any] = [:]
        var answerSubmission: [[String: Any]] = []
        switch questionType {
        case .multipleChoice, .multipleSelect:
            let solutions = studentAnswers[question.id!] ?? []
            let answers = question.answers ?? []
            for answer in answers {
                var isCorrect = false
                for solution in solutions {
                    isCorrect = answer.id == solution.id
                    if isCorrect {
                        break
                    }
                }
                answerSubmission.append(["answer_id": answer.id!,
                "match": "",
                "is_correct": isCorrect,
                "question_id": question.id!,
                "quiz_submission_id": submissionId])
            }
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = question.id!
        case .reorder:
            for (index, solution) in newOrder.enumerated() {
                answerSubmission.append(["answer_id": solution.id!,
                "match": "\(index + 1)",
                "question_id":question.id!,
                "quiz_submission_id": submissionId])
            }
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = question.id!
        case .match:
            for matchTuple in matchesMap {
                answerSubmission.append(["answer_id": matchTuple.value.id!,
                                         "match": matchTuple.key,
                                         "question_id":question.id!,
                                         "quiz_submission_id": submissionId])
            }
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = question.id!
        }
        return parameters
    }
    
    //    MARK: - Submit Answer
    func submitAnswer() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        postQuizAnswersSubmissionsApi(parameters: createAnswersDictionary()) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String: Any]] {
                    let tempQuestion = self.questions.first { (question) -> Bool in
                        question.id! == self.questions[self.currentQuestion].id ?? 0
                    }
                    if let question = tempQuestion {
                        if question.answers.count == 2 && question.answers[0].id == -(question.answers[1].id) {
                            var firstAnswerDict = result[0]
                            firstAnswerDict["id"] = firstAnswerDict["answer_id"]
                            let firstAnswerId = firstAnswerDict["answer_id"] as! Int
                            let firstAnswerIsCorrect = firstAnswerDict["answer_id"] as! Bool
                            var secondAnswerDict = result[0]
                            secondAnswerDict["id"] = -firstAnswerId
                            secondAnswerDict["is_correct"] = !firstAnswerIsCorrect
                            self.prevAnswers[question.id!] = [Answer(firstAnswerDict), Answer(secondAnswerDict)]
                            self.studentAnswers[question.id!] = [Answer(firstAnswerDict), Answer(secondAnswerDict)]
                        } else {
                            var answersDictArray: [[String: Any]] = []
                            for answerDictItem in result {
                                var tempAnswerDict = answerDictItem
                                tempAnswerDict["id"] = tempAnswerDict["answer_id"]
                                answersDictArray.append(tempAnswerDict)
                                if question.type == .match {
                                    let matchString = tempAnswerDict["match"] as! String
                                    let answerId = tempAnswerDict["answer_id"] as! Int
                                    question.answers.forEach({ (matchAnswer) in
                                        if matchAnswer.id == answerId {
                                            let option = Option.init(["id":matchAnswer.id!,
                                                                      "question_id":question.id!,
                                                                      "body": matchAnswer.body!])
                                            self.matchesMap[matchString] = option
                                        }
                                    })
                                    
                                }
                            }
                            self.prevAnswers[question.id!] = Set(answersDictArray.map{ Answer($0) })
                            self.studentAnswers[question.id!] = Set(answersDictArray.map{ Answer($0) })
                        }
                    }
                }
                self.currentQuestion += 1
                if self.currentQuestion < self.detailedQuiz.questions.count {
                    self.setUpQuestions()
                } else {
                    //                    self.submitQuiz()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
//    MARK: - Submit quiz
    func submitQuiz() {
        var parameters: [String: Any] = [:]
        parameters["submission"] = ["id": submissionId!]
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        submitQuizApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                debugPrint("Quiz is submitted successfully")
                self.backAction()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
//    MARK: - Delete submission
    func deleteSubmission() {
        let questionId = questions[currentQuestion].id ?? 0
        var parameters: [String: Any] = [:]
        parameters["quiz_submission_id"] = submissionId!
        parameters["question_id"] = questionId
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        deleteSubmissionApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                debugPrint("question submission deleted")
                self.deletionFlag = true
                self.currentQuestion += 1
                if self.currentQuestion < self.detailedQuiz.questions.count {
                    self.setUpQuestions()
                } else {
//                    self.submitQuiz()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    @IBAction func nextButtonAction() {
        if isSolvable {
            let questionId = questions[currentQuestion].id ?? 0
            if currentQuestion < detailedQuiz.questions.count {
                if (studentAnswers[questionId]?.isEmpty ?? true) && !(prevAnswers[questionId]?.isEmpty ?? true ) {
                    deleteSubmission()
                } else if shouldSkipSubmission() {
                    self.currentQuestion += 1
                    if self.currentQuestion < self.detailedQuiz.questions.count {
                        self.setUpQuestions()
                    } else {
                        //                self.submitQuiz()
                    }
                } else {
                    submitAnswer()
                }
            } else {
                //            TODO: call the submit grade api, call back action
                debugPrint("submit grade")
            }
        } else {
            if self.currentQuestion < self.detailedQuiz.questions.count - 1 {
                self.currentQuestion += 1
                self.setUpQuestions()
            } else {
                backAction()
            }
        }
        
        if let _ = outOfLabelHeight {
            NSLayoutConstraint.deactivate([outOfLabelHeight])
        }
        outOfLabel.isHidden = false
        previousButton.setTitle("Previous", for: .normal)
        
        if currentQuestion + 1 >= detailedQuiz.questions.count - 1 {
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
        guard let subId = submissionId else {
            return
        }
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizAnswersSubmissionsApi(submissionId: subId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : [[String: Any]]] {
                    for answerDict in result {
                         let tempQuestion = self.questions.first { (question) -> Bool in
                            question.id! == Int(answerDict.key) ?? 0
                        }
                        if let question = tempQuestion {
                            if question.answers.count == 2 && question.answers[0].id == -(question.answers[1].id) {
                                var firstAnswerDict = answerDict.value[0]
                                firstAnswerDict["id"] = firstAnswerDict["answer_id"]
                                let firstAnswerId = firstAnswerDict["answer_id"] as! Int
                                let firstAnswerIsCorrect = firstAnswerDict["answer_id"] as! Bool
                                var secondAnswerDict = answerDict.value[0]
                                secondAnswerDict["id"] = -firstAnswerId
                                secondAnswerDict["is_correct"] = !firstAnswerIsCorrect
                                self.prevAnswers[question.id!] = [Answer(firstAnswerDict), Answer(secondAnswerDict)]
                                self.studentAnswers[question.id!] = [Answer(firstAnswerDict), Answer(secondAnswerDict)]
                            } else {
                                var answersDictArray: [[String: Any]] = []
                                for answerDictItem in answerDict.value {
                                    var tempAnswerDict = answerDictItem
                                    tempAnswerDict["id"] = tempAnswerDict["answer_id"]
                                    answersDictArray.append(tempAnswerDict)
                                    if question.type == .match {
                                        let matchString = tempAnswerDict["match"] as! String
                                        let answerId = tempAnswerDict["answer_id"] as! Int
                                        question.answers.forEach({ (matchAnswer) in
                                            if matchAnswer.id == answerId {
                                                let option = Option.init(["id":matchAnswer.id!,
                                                                          "question_id":question.id!,
                                                                          "body": matchAnswer.body!])
                                                self.matchesMap[matchString] = option
                                            }
                                        })
                                        
                                    }
                                }
                                self.prevAnswers[question.id!] = Set(answersDictArray.map{ Answer($0) })
                                self.studentAnswers[question.id!] = Set(answersDictArray.map{ Answer($0) })
                            }
                        }
                    }
                    
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
        return tableViewDataSourceArray.count
    }
    //    MARK: - Handle cells
    fileprivate func handleQuestionCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuizQuestionTableViewCell
        cell.questionType = questions[currentQuestion].type
        if let question = tableViewDataSourceArray[indexPath.row] as? Questions{
            cell.question = question
            cell.questionBodyView.update(input: question.body)
        } else {
            if let option = tableViewDataSourceArray[indexPath.row] as? Option {
                cell.option = option
                cell.questionBodyView.update(input: option.body)
                cell.matchIndex = indexPath.row
            }
        }
        return cell
    }
    
    fileprivate func handleTitleCell(_ tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerLabelCell") as! QuizAnswerLabelTableViewCell
        return cell
    }
    
    fileprivate func handleReorderCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
        cell.questionType = .reorder
        cell.isAnswers = isAnswers
        if !newOrder.isEmpty {
            cell.answer = newOrder[indexPath.row - 2]
        }
        return cell
    }
    
    fileprivate func handleMatchCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
        let matchString = tableViewDataSourceArray[indexPath.row] as? String ?? ""
        cell.questionType = .match
        cell.isAnswers = isAnswers
        cell.matchString = matchString
        cell.matchTextField.text = ""
        cell.updateMatchAnswer = { (matchIndex, matchString) in
            self.matchAnswers(matchIndex: matchIndex, matchString: matchString)
        }
        if isAnswers || isQuestionsOnly {
            for (index, option) in options.enumerated() {
                if let matchOption = matchesMap[matchString], matchOption == option {
                    cell.matchTextField.text = "\(index + 1)"
                }
            }
        } else {
            if let options = self.detailedQuiz.questions[self.currentQuestion].answers.first?.options {
                for (index, option) in options.enumerated() {
                    if let matchOption = matchesMap[matchString], matchOption == option {
                        cell.matchTextField.text = "\(index + 1)"
                    }
                }
            }
        }
        if isAnswers || isQuestionsOnly {
            cell.matchTextField.isUserInteractionEnabled = false
        }
        return cell
    }
    
    fileprivate func handleDefaultCell(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
        cell.questionType = questions[currentQuestion].type
        if let selectedAnswer = tableViewDataSourceArray[indexPath.row] as? Answer, let answers = studentAnswers[questions[currentQuestion].id!] {
            for answer in answers {
                if answer.id == selectedAnswer.id {
                    cell.isAnswerSelected = answer.isCorrect
                }
            }
        }
        cell.answer = tableViewDataSourceArray[indexPath.row] as? Answer
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewDataSourceArray[indexPath.row] is Questions || tableViewDataSourceArray[indexPath.row] is Option {
            return handleQuestionCell(tableView, indexPath)
        } else if let title = tableViewDataSourceArray[indexPath.row] as? String, title.elementsEqual("headerCell") {
            return handleTitleCell(tableView)
        } else {
            let questionType = questions[currentQuestion].type!
            switch questionType {
            case .reorder:
                return handleReorderCell(tableView, indexPath)
            case .match:
                return handleMatchCell(tableView, indexPath)
            default:
                return handleDefaultCell(tableView, indexPath)
            }
        }
    }
    
    //    MARK: - didSelectRow
    
    fileprivate func handleMultiSelectAnswers(_ indexPath: IndexPath, _ answers: Set<Answer>) -> Set<Answer>{
        var newAnswers: Set<Answer> = []
        let dataSourceAnswer = tableViewDataSourceArray[indexPath.row] as! Answer
        for answer in answers {
            let newAnswer = answer
            if answer.id == dataSourceAnswer.id {
                newAnswer.isCorrect = !answer.isCorrect
            }
            newAnswers.insert(newAnswer)
        }
        return newAnswers
    }
    
    fileprivate func handleMultipleChoiceAnswers(_ indexPath: IndexPath, _ answers: Set<Answer>) -> Set<Answer>{
        var newAnswers: Set<Answer> = []
        let dataSourceAnswer = tableViewDataSourceArray[indexPath.row] as! Answer
        for answer in answers {
            let newAnswer = answer
            if answer.id == dataSourceAnswer.id {
                newAnswer.isCorrect = true
            } else {
                newAnswer.isCorrect = false
            }
            newAnswers.insert(newAnswer)
        }
        return newAnswers
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? QuizAnswerTableViewCell {
            let questionType = questions[currentQuestion].type!
            let questionId = questions[currentQuestion].id ?? 0
            switch questionType {
            case .multipleSelect:
                cell.matchTextField.resignFirstResponder()
                if let answers = studentAnswers[questionId], !answers.isEmpty {
                    studentAnswers[questionId] = handleMultiSelectAnswers(indexPath, answers)
                } else {
                    let answers = self.questions[currentQuestion].answers ?? []
                    studentAnswers[questionId] = handleMultiSelectAnswers(indexPath, Set(answers))
                }
            case .multipleChoice:
                cell.matchTextField.resignFirstResponder()
                if let answers = studentAnswers[questionId], !answers.isEmpty {
                    studentAnswers[questionId] = handleMultipleChoiceAnswers(indexPath, answers)
                } else {
                    let answers = self.questions[currentQuestion].answers ?? []
                    studentAnswers[questionId] = handleMultipleChoiceAnswers(indexPath, Set(answers))
                }
                
            case .match:
                cell.matchTextField.becomeFirstResponder()
            case .reorder:
                cell.matchTextField.resignFirstResponder()
            }
        }
        tableView.reloadData()
        
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
            for (index, anyAnswer) in self.tableViewDataSourceArray.enumerated() {
                if let answer = anyAnswer as? Answer {
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
            if let answer = tableViewDataSourceArray[indexPath.row] as? Answer {
                string = answer.body!
            }
            guard let data = string.data(using: .utf8) else { return [] }
            let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
            return [UIDragItem(itemProvider: itemProvider)]
        }
    }
    
}
