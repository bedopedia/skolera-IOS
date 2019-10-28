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
    var newOrder: [Answer] = []
    var isQuestionsOnly = false
    var isAnswers = false
    var courseGroupId: Int!
    var duration: Int!
    var previousAnswers: [String : [Any]]!
    var matchesMap: [String: Option]!
    var trueOrFlaseAnswers: [Answer]!    //from the previousAnswers array
    var multipleChoicesAnswers: [Answer]!
    var multiSelectAnswers: [Answer]!
    var deletionFlag = false
    var options: [Option] = []
    
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
        matchesMap = [:]
        trueOrFlaseAnswers = []
        multipleChoicesAnswers = []
        multiSelectAnswers = []
        //        detailedDummyQuiz = DetailedQuiz.init(dummyResponse2())
        //        setUpQuestions()
        NSLayoutConstraint.deactivate([outOfLabelHeight])
        previousButtonAction()
        if isQuestionsOnly || isAnswers {
            timerLabel.isHidden = true
            tableView.allowsSelection = false
            NSLayoutConstraint.deactivate([timerLabelTopConstraint])
            backButtonAllignment.constant = 0
            headerHeightConstraint.constant = 60
            setUpQuestions()
        } else {
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
    func sortReorderQuestion() {
        guard let answers = detailedQuiz.questions[currentQuestion].answers else {
            return
        }
        let questionId = detailedQuiz.questions[currentQuestion].id
        if isAnswers || isQuestionsOnly {
            newOrder = answers.sorted(by: { (answer1, answer2) -> Bool in
                answer1.match < answer2.match
            })
        } else {
            if let prevAnswers = previousAnswers["\(questionId!)"] {
                answeredQuestions[detailedQuiz.questions[currentQuestion]] = prevAnswers
                if let submittedAnswers = answeredQuestions[detailedQuiz.questions[currentQuestion]] {
                    let orderedAnswers = submittedAnswers.sorted { (answer1, answer2) -> Bool in
                        guard let answer1Dict = answer1 as? [String: Any],
                            let answer2Dict = answer2 as? [String: Any],
                            let first = answer1Dict["match"] as? String,
                            let second = answer2Dict["match"] as? String  else {
                                return false
                        }
                        return first < second
                    }
                    for answer in orderedAnswers {
                        if let answerDict = answer as? [String: Any], let answerId = answerDict["answer_id"] as? Int {
                            let matchedModel = answers.first(where: { (answer) -> Bool in
                                answerId == answer.id
                            })
                            if let modelledAnswer = matchedModel {
                                newOrder.append(modelledAnswer)
                            } else {
                                continue
                            }
                            
                        }
                    }
                }
            } else {
                if newOrder.isEmpty {
                    newOrder = answers
                }
            }
        }
    }
    //    MARK: - Data setup
    func setUpQuestions() {
        if self.deletionFlag {
            self.deletionFlag = false
            getAnswers()
        } else {
            let question = detailedQuiz.questions[currentQuestion]
            questionType = question.type.map({ QuestionTypes(rawValue: $0)! })
            questions = []
            //        let question = detailedDummyQuiz.questions[currentQuestion]
            if !isQuestionsOnly && !isAnswers {
                tableView.dragInteractionEnabled = true
            } else {
                tableView.dragInteractionEnabled = false
            }
            questions.append(question)
            
            //      TO:DO  check is th question type is match and append the match model
            if questionType == QuestionTypes.trueOrFalse {
                if isAnswers || isQuestionsOnly {
                    let isCorrect = question.answers.first?.isCorrect
                    answeredQuestions[detailedQuiz.questions[ currentQuestion]] = [Answer.init(["id": question.answers.first?.id ?? 0,
                                                                                                "question_id": question.answers.first?.questionId ?? 0,
                                                                                                "is_correct": isCorrect ?? false,
                                                                                                "body": "\(isCorrect!)"
                    ])]
                }
                questions.append("headerCell")
                let correctanswer = Answer.init(["id": question.answers.first?.id ?? 0 ,
                                                 "body": "true",
                                                 "question_id": question.answers.first?.questionId ?? 0,
                                                 "is_correct": true
                ])
                questions.append(correctanswer)
                let falseAnswer = Answer.init(["id": question.answers.first?.id ?? 0 ,
                                               "body": "false",
                                               "question_id": question.answers.first?.questionId ?? 0,
                                               "is_correct": false
                ])
                questions.append(falseAnswer)
                
            } else {
                if questionType == QuestionTypes.reorder {
                    sortReorderQuestion()
                }
                if questionType == QuestionTypes.match {
                    if isQuestionsOnly || isAnswers {
//                        construct options
                        answeredQuestions[question] = []
                        
                        question.answers.forEach({ (matchAnswer) in
                            //                    build the matches map
                            let option = Option.init(["id":matchAnswer.id!,
                            "question_id":question.id!,
                            "body": matchAnswer.body!])
                            questions.append(option)
                            options.append(option)
                            matchesMap[matchAnswer.match!] = option
                        })
                        questions.append("headerCell")
                        question.answers.forEach({ (matchAnswer) in
                            //                    build the matches map
                            questions.append(matchAnswer.match)
                        })
                    } else {
                        answeredQuestions[question] = []
                        //                should divide the answers and append them all here
                        question.answers.first?.options.forEach({ (option) in
                            var matchTuple:[Option: String] = [:]
                            matchTuple[option] = ""
                            questions.append(option)
                            //                    build the matches map
                            answeredQuestions[question]?.append(matchTuple)
                        })
                        questions.append("headerCell")
                        question.answers.first?.matches.forEach({ (match) in
                            questions.append(match)
                        })
                    }
                } else {    //mc ans ms
                    questions.append("headerCell")
                    question.answers?.forEach{ (answer) in
                        questions.append(answer)
                    }
                    if isAnswers || isQuestionsOnly {
                        var answers: [Answer] = []
                        question.answers?.forEach{ (answer) in
                            if let isCorrect = answer.isCorrect, isCorrect {
                                answers.append(Answer.init(["id": answer.id ?? 0,
                                                            "question_id": question.answers.first?.questionId ?? 0,
                                                            "is_correct": isCorrect,
                                                            "body": answer.body!
                                ]))
                            }
                            answeredQuestions[detailedQuiz.questions[ currentQuestion]] = answers
                        }
                    }
                }
            }
            showAnswers()
            outOfLabel.text = "\(currentQuestion + 1) Out of \(detailedQuiz.questions.count)"
            setTableViewMultipleSelection(question: question)
            if isAnswers {
                //            showAnswers()
            }
            tableView.reloadData()
        }
    }
   
    func showAnswers() {
        let questionId  = detailedQuiz.questions[currentQuestion].id!
        
        if questionType == QuestionTypes.match {
            guard let _ = self.detailedQuiz.questions[self.currentQuestion].answers.first?.options, let previousArray = previousAnswers["\(questionId)"], let answers = answeredQuestions[detailedQuiz.questions[currentQuestion]] else {
                return
            }
            var replacement: [[Option: String]] = []
            matchesMap = [:]
            //            populate the answers attributes with the correct answers from the call if available
            for previousAnswer in previousArray {
                if let previousDict = previousAnswer as? [String: Any], let prevId = previousDict["answer_id"] as? Int {
                    for answer in answers {
                        if let answerDict = answer as? [Option: String] {
                            let keys = answerDict.keys
                            if let answerId = keys.first?.id, answerId == prevId {
                                if let option = keys.first, let matchString = previousDict["match"] as? String {
                                    replacement.append([option: matchString ])
                                    matchesMap[matchString] = option
                                }
                            }
                        }
                    }
                }
            }
            
            self.answeredQuestions[detailedQuiz.questions[currentQuestion]] = replacement
            
        } else {
            guard let answers = detailedQuiz.questions[currentQuestion].answers else {
                return
            }
            if let answersArray = previousAnswers["\(questionId)"] {
                answeredQuestions[detailedQuiz.questions[currentQuestion]] = []
                //            answeredQuestions[detailedQuiz.questions[currentQuestion]] = answersArray
                answersArray.forEach { (prevAnswer) in
                    if let answerDict = prevAnswer as? [String: Any] {
                        for answer in answers {
                            if let answerId = answerDict["answer_id"] as? Int, answerId == answer.id {
                                answeredQuestions[detailedQuiz.questions[currentQuestion]]?.append(prevAnswer)
                                trueOrFlaseAnswers.append(Answer.init(answerDict))
                            }
                        }
                    }
                }
                //                trueOrFlaseAnswers = answeredQuestions[detailedQuiz.questions[currentQuestion]]?.map({
                //                    Answer($0)
                //                })
                //                multiSelectAnswers = answeredQuestions[detailedQuiz.questions[currentQuestion]]
                //                multipleChoicesAnswers = answeredQuestions[detailedQuiz.questions[currentQuestion]]
            }
        }
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
        booleanValue ? "True" : "False"
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
    func checksTheAnswer() -> Bool {
        var isContained = false
        if let previousAnswersArray = previousAnswers?["\(detailedQuiz.questions[currentQuestion].id!)"] as? [[String: Any]] {
            if let answers = answeredQuestions[detailedQuiz.questions[currentQuestion]] {
                switch questionType {
                case .multipleChoice, .trueOrFalse:
                    isContained =  previousAnswersArray.contains(where: { (prevAnswer) -> Bool in
                        if let prevAnswerId = prevAnswer["answer_id"] as? Int, let selectedAnswer = answers.first as? [String: Any], let selectedAnswerId = selectedAnswer["answer_id"] as? Int {
                            if prevAnswerId == selectedAnswerId {
                                if let prev = prevAnswer["is_correct"] as? Bool, let selected = selectedAnswer["is_correct"] as? Bool, prev == selected {
                                    return true
                                } else {
                                    return false
                                }
                            }
                        }
                        return false
                    })
                case .multipleSelect:
                    for multiSelect in answers {
                        if let modelledAnswer = multiSelect as? Answer {
                            isContained = previousAnswersArray.contains { (prevDict) -> Bool in
                                if let prevAnswerId = prevDict["answer_id"] as? Int, prevAnswerId == modelledAnswer.id!, let prevAnswerIsCorrect = prevDict["is_correct"] as? Bool, prevAnswerIsCorrect == modelledAnswer.isCorrect! {
                                    return true
                                }
                                return false
                            }
                        } else {
                            if let answerDict = multiSelect as? [String: Any] {
                                isContained = previousAnswersArray.contains { (prevDict) -> Bool in
                                    if let prevAnswerId = prevDict["answer_id"] as? Int, let answerId = answerDict["answer_id"] as? Int, prevAnswerId == answerId, let prevAnswerIsCorrect = prevDict["is_correct"] as? Bool, let isCorrect = answerDict["is_correct"] as? Bool, prevAnswerIsCorrect == isCorrect {
                                        return true
                                    } else {
                                        return false
                                    }
                                }
                            }
                        }
                    }
                    
                    
                case .match:
                    isContained = true
                    for match in matchesMap {
                        if isContained {
                            isContained = previousAnswersArray.contains { (prevDict) -> Bool in
                                if let prevId = prevDict["answer_id"] as? Int, prevId == match.value.id!, let prevMatch = prevDict["match"] as? String, prevMatch.elementsEqual(match.key) {
                                    return true
                                } else {
                                    return false
                                }
                            }
                        } else {
                            break
                        }
                    }
                    
                case .reorder:
                    for (index, orderAnswer) in newOrder.enumerated() {
                        let prevAnswer = previousAnswersArray.first(where: { (prevDict) -> Bool in
                            if let prevId = prevDict["answer_id"] as? Int, prevId == orderAnswer.id! {
                                return true
                            } else {
                                return false
                            }
                        })
                        if let prevBody = prevAnswer?["match"] as? String, prevBody.elementsEqual("\(index + 1)") {
                            isContained = true
                        } else {
                            isContained = false
                            break
                        }
                    }
                case .none:
                    debugPrint("Check is due")
                }
            }
        } else {
            //            check to handle deletion, no answer so the question should be skipped
            if let _ = answeredQuestions[detailedQuiz.questions[currentQuestion]] {
                debugPrint("")
            } else {
                if questionType == QuestionTypes.multipleSelect {
                    isContained = true
                }
            }
            
            if matchesMap.isEmpty, questionType == QuestionTypes.match {
                isContained = true
            }
        }
        return isContained
    }
    func createAnswersDictionary() -> [String: Any] {
        
        guard let answers = answeredQuestions[detailedQuiz.questions[currentQuestion]] else {
            return [:]
        }
        guard  let answersAttributes = detailedQuiz.questions[currentQuestion].answers else {
            return [:]
        }
        var parameters: [String: Any] = [:]
        var answerSubmission: [[String: Any]] = [[:]]
        switch questionType {
        case .trueOrFalse:
            guard let answer = answers.first as? Answer else {
                return [:]
            }
            answerSubmission.append(["answer_id": answer.id!,
                                     "match": "",
                                     "is_correct":answer.isCorrect!,
                                     "question_id":detailedQuiz.questions[currentQuestion].id!,
                                     "quiz_submission_id": submissionId])
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = detailedQuiz.questions[currentQuestion].id!
        case .multipleSelect, .multipleChoice:
            for answer in answers {
                //                the array is of type Answer
                if let modelledAnswer = answer as? [String: Any] {  // from the answers api
                    answerSubmission.append(["answer_id": modelledAnswer["answer_id"]!,
                                             "match": "",
                                             "is_correct":modelledAnswer["is_correct"]!,
                                             "question_id":detailedQuiz.questions[currentQuestion].id!,
                                             "quiz_submission_id": submissionId])
                } else {    //from the student solution
                    if let modelledAnswer = answer as? Answer {
                        answerSubmission.append(["answer_id": modelledAnswer.id!,
                                                 "match": "",
                                                 "is_correct":modelledAnswer.isCorrect,
                                                 "question_id":modelledAnswer.questionId!,
                                                 "quiz_submission_id": submissionId])
                    }
                }
            }
            
            for answer in answersAttributes {
                var isContained = answers.contains(where: { (solved) -> Bool in
                    if let solved = answer as? [String: Any], let solvedId = solved["answer_id"] as? Int, solvedId == answer.id! {
                        return true
                    } else {
                        if let solved = answer as? Answer, solved.id == answer.id {
                            return true
                        } else {
                            return false
                        }
                    }
                })
                if !isContained {
                    answerSubmission.append(["answer_id": answer.id!,
                                             "match": "",
                                             "is_correct":answer.isCorrect,
                                             "question_id":answer.questionId!,
                                             "quiz_submission_id": submissionId])
                }
            }
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = detailedQuiz.questions[currentQuestion].id!
        case .reorder:
            debugPrint("")
            for (index, answer) in newOrder.enumerated() {
                answerSubmission.append(["answer_id": answer.id!,
                                         "match": "\(index + 1)",
                    "question_id":answer.questionId!,
                    "quiz_submission_id": submissionId])
            }
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = detailedQuiz.questions[currentQuestion].id!
        case .match:
            for match in matchesMap {
                let option = match.value
                answerSubmission.append(["answer_id": option.id!,
                                         "match": match.key,
                                         "question_id":option.questionId!,
                                         "quiz_submission_id": submissionId])
            }
            parameters["answer_submission"] = answerSubmission
            parameters["question_id"] = detailedQuiz.questions[currentQuestion].id!
        case .none:
            debugPrint("")
        }
        //                should check the question type, in case of true or false
        return parameters
    }
    //    MARK: - Submit Answer
    func submitAnswer() {
        if checksTheAnswer() {
            //            skip this question
            self.currentQuestion += 1
            if self.currentQuestion < self.detailedQuiz.questions.count {
                self.setUpQuestions()
            } else {
                //                self.submitQuiz()
            }
            return
        }
        
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        postQuizAnswersSubmissionsApi(parameters: createAnswersDictionary()) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                let questionId = self.detailedQuiz.questions[self.currentQuestion].id!
                if let result = value as? [[String: Any]] {
                    self.previousAnswers["\(questionId)"] = result
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
    
    func deleteSubmission() {
        let questionId = detailedQuiz.questions[currentQuestion].id
        var parameters: [String: Any] = [:]
        parameters["quiz_submission_id"] = submissionId!
        parameters["question_id"] = questionId ?? 0
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        deleteSubmissionApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                debugPrint("question submission deleted")
                self.deletionFlag = true
                self.currentQuestion += 1
                if self.currentQuestion < self.detailedQuiz.questions.count {
                    self.setUpQuestions()
                }
                
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    @IBAction func nextButtonAction() {
        if !isAnswers && !isQuestionsOnly {
            if currentQuestion < detailedQuiz.questions.count {
                let questionId = detailedQuiz.questions[currentQuestion].id
                if let previousAnswersArray = previousAnswers["\(questionId!)"] {
                    if !previousAnswersArray.isEmpty {
                        if  questionType == QuestionTypes.multipleSelect {
                            if answeredQuestions[detailedQuiz.questions[currentQuestion]]!.isEmpty {
                                deleteSubmission()
                            } else {
                                submitAnswer()
                            }
                        }
                        else {
                            if questionType == QuestionTypes.match {
                                if matchesMap.isEmpty {
                                    deleteSubmission()
                                } else {
                                    submitAnswer()
                                }
                            } else {
                                submitAnswer()
                            }
                        }
                    } else {
                        submitAnswer()
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
                //               go to home
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
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getQuizAnswersSubmissionsApi(submissionId: submissionId) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : [Any]] {
                    debugPrint(result)
                    self.previousAnswers = result
                    self.setUpQuestions()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    //    MARK: - Match Answers
    func matchAnswers(matchIndex: String!, matchString: String) {
        if matchIndex.isEmpty {
            debugPrint("empty")
            if let match = matchesMap[matchString] {
                matchesMap.removeValue(forKey: matchString)
            }
        } else {
            guard let arrayIndex = Int(matchIndex ?? "") else {
                return
            }
            guard let answers = self.answeredQuestions[self.detailedQuiz.questions[self.currentQuestion]] else {
                return
            }
            guard let options = self.detailedQuiz.questions[self.currentQuestion].answers.first?.options else {
                return
            }
            //        remove this option from the matches map and then add it to this specific matchString
            if answers.indices.contains(arrayIndex - 1) {
                let optionIndex = arrayIndex - 1
                let option = options[optionIndex]
                for match in matchesMap {
                    if match.value == option {
                        matchesMap.removeValue(forKey: match.key)
                    }
                }
                matchesMap[matchString] = option
            }
        }
        
        self.tableView.reloadData()
    }
}
//MARK: - Table view Extension

extension SolveQuizViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    //    MARK: - cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if questions[indexPath.row] is Questions || questions[indexPath.row] is Option {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuizQuestionTableViewCell
            cell.questionType = questionType
            if let question = questions[indexPath.row] as? Questions{
                cell.question = question
                cell.questionBodyView.update(input: question.body)
            } else {
                if let option = questions[indexPath.row] as? Option {
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
                    guard let matchString = questions[indexPath.row] as? String else {
                        break
                    }
                    cell.matchString = matchString
                    cell.updateMatchAnswer = { (matchIndex, matchString) in
                        self.matchAnswers(matchIndex: matchIndex, matchString: matchString)
                    }
                    if isAnswers || isQuestionsOnly {
                        for (index, option) in options.enumerated() {
                            if let matchOption = matchesMap[matchString] {
                                if matchOption == option {
                                    cell.matchTextField.text = "\(index + 1)"
                                }
                                
                            } else {
                                cell.matchTextField.text = ""
                            }
                        }
                    } else {
                        if let options = self.detailedQuiz.questions[self.currentQuestion].answers.first?.options {
                            for (index, option) in options.enumerated() {
                                if let matchOption = matchesMap[matchString] {
                                    if matchOption == option {
                                        cell.matchTextField.text = "\(index + 1)"
                                    }
                                    
                                } else {
                                    cell.matchTextField.text = ""
                                }
                            }
                        } else {
                            cell.matchTextField.text = ""
                        }
                    }
                case .reorder:
                    if !newOrder.isEmpty {
                        cell.answer = newOrder[indexPath.row - 2]
                    }
                    
                default:
                    if let selectedAnswer = questions[indexPath.row] as? Answer, let answers = answeredQuestions[detailedQuiz.questions[currentQuestion]] {
                        for answer in answers {
                            if let modelledAnswer = answer as? Answer {
                                //                          in case of using the answers api
                                if isAnswers && questionType! == .trueOrFalse {
                                    if (selectedAnswer.body?.elementsEqual(stringValue(booleanValue: selectedAnswer.isCorrect!)))! {
                                        cell.setSelectedImage()
                                    }
                                } else {
                                    if modelledAnswer.id == selectedAnswer.id {
                                        if questionType == QuestionTypes.trueOrFalse {
                                            if modelledAnswer.body == selectedAnswer.body {
                                                cell.setSelectedImage()
                                            }
                                        } else {
                                            if modelledAnswer.isCorrect {
                                                cell.setSelectedImage()
                                            }
                                        }
                                    }
                                }
                            } else {
                                //                              answers from get submissions api
                                if let answerDict = answer as? [String: Any] {
                                    if questionType == QuestionTypes.trueOrFalse {
                                        if let trueOrFalse = answerDict["is_correct"] as? Bool{
                                            if trueOrFalse == selectedAnswer.isCorrect! {
                                                cell.setSelectedImage()
                                            }
                                        }
                                    } else {
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
                    cell.answer = questions[indexPath.row] as? Answer
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
        if var previousAnswers = answeredQuestions[detailedQuiz.questions[currentQuestion]], questionType == QuestionTypes.multipleSelect {
            //check that the current selection doesn't exist in the answers array
            var flag: Bool = true
            var answerToBeRemovedIndex: Int!
            if let selectedAnswer = questions[indexPath.row] as? Answer {
                for (index, answer) in previousAnswers.enumerated() {
                    if flag == true {
                        if let validAnswer = answer as? [String: Any], let validAnswerId = validAnswer["answer_id"] as? Int, validAnswerId == selectedAnswer.id {
                            answerToBeRemovedIndex = index
                            flag = false
                            break
                        } else if let validAnswer = answer as? Answer {
                            if validAnswer.id! == selectedAnswer.id {
                                answerToBeRemovedIndex = index
                                //                                debugPrint(selectedAnswer.id, validAnswerId, index)
                                flag = false
                                break
                            }
                        }
                    }
                }
                if flag {
                    answeredQuestions[detailedQuiz.questions[currentQuestion]]?.append(Answer.init(["id": selectedAnswer.id!,
                                                                                                    "question_id": selectedAnswer.questionId,
                                                                                                    "match": "",
                                                                                                    "is_correct": true
                    ]))
                } else {
                    if answerToBeRemovedIndex != nil {
                        previousAnswers.remove(at: answerToBeRemovedIndex)
                        answeredQuestions[detailedQuiz.questions[currentQuestion]] = previousAnswers
                        tableView.reloadData()
                    }
                }
            }
        } else {
            if let validAnswer = questions[indexPath.row] as? Answer {
                //                    should make isCorrect true, should append the value from answers model
                var boolValue = false
                if validAnswer.body.elementsEqual("true") {
                    boolValue = true
                }
                let questionId = detailedQuiz.questions[currentQuestion].answers?.first?.questionId
                if questionType == QuestionTypes.trueOrFalse {
                    answeredQuestions[detailedQuiz.questions[ currentQuestion]] = [Answer.init(["id": validAnswer.id!,
                                                                                                "question_id": questionId!,
                                                                                                "match": "",
                                                                                                "is_correct": boolValue,
                                                                                                "body": "\(boolValue)"
                    ])]
                } else {
                    answeredQuestions[detailedQuiz.questions[ currentQuestion]] = [Answer.init(["id": validAnswer.id!,
                                                                                                "question_id": questionId!,
                                                                                                "match": "",
                                                                                                "is_correct": true
                    ])]
                }
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
            for (index, anyAnswer) in self.questions.enumerated() {
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
            if let answer = questions[indexPath.row] as? Answer {
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
