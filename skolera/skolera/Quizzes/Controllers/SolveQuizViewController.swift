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
    
    var duration = 60 {
        didSet{
            timerLabel.text = timeString(time: TimeInterval(duration))
        }
    }
    var timer = Timer()
    var isTimerRunning = false
    var savedDuration = 0
    var answers = ["ans 1", "ans 2", "ans 3" ,"ans 4"]
    
    var detailedQuiz: DetailedQuiz!
    var currentQuestion = 0
    var questions: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if #available(iOS 11.0, *) {
            tableView.dropDelegate = self
            tableView.dragDelegate = self
            tableView.dragInteractionEnabled = true
        } 
        tableView.delegate = self
        tableView.dataSource = self
        detailedQuiz = DetailedQuiz.init(dummyResponse())
        setUpQuestions()
        NSLayoutConstraint.deactivate([outOfLabelHeight])
        previousButtonAction()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isTimerRunning {
            runTimer()
        }
        NotificationCenter.default.addObserver(forName: .UIApplicationDidEnterBackground, object: nil, queue: nil) { (notification) in
            debugPrint("back ground mode")
            UserDefaults.standard.set(Date().second, forKey: "timerDuration")
        }
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { (notification) in
            if let timerDuration = UserDefaults.standard.string(forKey: "timerDuration") {
                self.duration -= ( Date().second - Int(timerDuration)! )
                debugPrint("was in the background for:", Date().second - Int(timerDuration)!)
            }
        }
    }
    
 
 
    
    @IBAction func backAction() {
        self.navigationController?.popToRootViewController(animated: true)
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
            navigateToHome()
        } else {
            duration -= 1
        }
    }
    
    func navigateToHome() {
        let submitQuiz = QuizSubmissionViewController.instantiate(fromAppStoryboard: .Quizzes)
        submitQuiz.openQuizStatus = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.navigationController?.navigationController?.present(submitQuiz, animated: true, completion: nil)
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func nextButtonAction() {
        if currentQuestion < detailedQuiz.questions.count - 1 {
            currentQuestion += 1
            setUpQuestions()
        }
        if let _ = outOfLabelHeight {
            NSLayoutConstraint.deactivate([outOfLabelHeight])
        }
        outOfLabel.isHidden = false
        previousButton.setTitle("Previous", for: .normal)
        
        if currentQuestion == detailedQuiz.questions.count - 1 {
            nextButton.setTitle("Submit", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction func previousButtonAction() {
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
        questions.append(question)
        //      TO:DO  check is th question type is match and append the match model
        questions.append("Answers")
        question.answersAttributes?.forEach{ (answer) in
            questions.append(answer)
        }
        outOfLabel.text = "\(currentQuestion + 1) Out of \(detailedQuiz.questions.count)"
//        previousButtonAction()
        tableView.reloadData()
    }
    
    func dummyResponse() -> [String: Any] {
        return [
            "id": 94,
            "name": "uuu",
            "start_date": "2019-07-11T00:00:00.000Z",
            "end_date": "2019-07-18T00:00:00.000Z",
            "description": "",
            "course_groups": [
                [
                    "name": "18A",
                    "id": 516,
                    "students": 20
                ],
                [
                    "name": "18B",
                    "id": 532,
                    "students": 18
                ]
            ],
            "category": "",
            "lesson": [
                "id": 247,
                "name": "General",
                "unit_id": 247,
                "description": "",
                "date": "",
                "order": 0,
                "created_at": "2018-09-01T18:03:56.000Z",
                "updated_at": "2018-09-01T18:03:56.000Z",
                "deleted_at": ""
            ],
            "unit": [
                "id": 247,
                "name": "General",
                "chapter_id": 247,
                "description": "",
                "order": 0,
                "created_at": "2018-09-01T18:03:56.000Z",
                "updated_at": "2018-09-01T18:03:56.000Z",
                "deleted_at": ""
            ],
            "chapter": [
                "id": 247,
                "name": "General",
                "course_id": 247,
                "description": "",
                "order": 0,
                "created_at": "2018-09-01T18:03:56.000Z",
                "updated_at": "2018-09-01T18:03:56.000Z",
                "lock": true,
                "deleted_at": ""
            ],
            "duration": 5,
            "is_questions_randomized": false,
            "num_of_questions_per_page": 5,
            "state": "running",
            "total_score": 26.0,
            "lesson_id": 247,
            "student_solved": true,
            "blooms": [],
            "grading_period_lock": false,
            "grading_period": "",
            "questions": [
                [
                    "id": 231,
                    "body": "<p>m,mjkj</p>",
                    "difficulty": "Easy",
                    "score": 5.0,
                    "answers_attributes": [
                        [
                            "id": 579,
                            "body": "234",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 231,
                            "match": "234",
                            "deleted_at": ""
                        ],
                        [
                            "id": 578,
                            "body": "123",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 231,
                            "match": "123",
                            "deleted_at": ""
                        ]
                    ],
                    "correction_style": "",
                    "type": "Match",
                    "bloom": [],
                    "files": "",
                    "uploaded_file": "",
                    "correct_answers_count": 0
                ],
                [
                    "id": 232,
                    "body": "<p>hguyu</p>",
                    "difficulty": "Easy",
                    "score": 5.0,
                    "answers_attributes": [
                        [
                            "id": 581,
                            "body": "98766",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 232,
                            "match": "",
                            "deleted_at": ""
                        ],
                        [
                            "id": 580,
                            "body": "12345",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 232,
                            "match": "",
                            "deleted_at": ""
                        ],
                        [
                            "id": 582,
                            "body": "5565",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 232,
                            "match": "",
                            "deleted_at": ""
                        ]
                    ],
                    "correction_style": "",
                    "type": "MultipleSelect",
                    "bloom": [],
                    "files": "",
                    "uploaded_file": "",
                    "correct_answers_count": 1
                ],
                [
                    "id": 233,
                    "body": "<p>choose</p>",
                    "difficulty": "Easy",
                    "score": 6.0,
                    "answers_attributes": [
                        [
                            "id": 584,
                            "body": "jk",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 233,
                            "match": "",
                            "deleted_at": ""
                        ],
                        [
                            "id": 583,
                            "body": "jhk",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 233,
                            "match": "",
                            "deleted_at": ""
                        ]
                    ],
                    "correction_style": "",
                    "type": "MultipleChoice",
                    "bloom": [],
                    "files": "",
                    "uploaded_file": "",
                    "correct_answers_count": 1
                ],
                [
                    "id": 234,
                    "body": "<p>jhkh</p>",
                    "difficulty": "Easy",
                    "score": 5.0,
                    "answers_attributes": [
                        [
                            "id": 587,
                            "body": "7777",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 234,
                            "match": "2",
                            "deleted_at": ""
                        ],
                        [
                            "id": 585,
                            "body": "5555",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 234,
                            "match": "0",
                            "deleted_at": ""
                        ],
                        [
                            "id": 586,
                            "body": "6666",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 234,
                            "match": "1",
                            "deleted_at": ""
                        ]
                    ],
                    "correction_style": "",
                    "type": "Reorder",
                    "bloom": [],
                    "files": "",
                    "uploaded_file": "",
                    "correct_answers_count": 0
                ],
                [
                    "id": 235,
                    "body": "<p>khkhk</p>",
                    "difficulty": "Easy",
                    "score": 5.0,
                    "answers_attributes": [
                        [
                            "id": 588,
                            "body": "answer",
                            "created_at": "2019-05-15T11:10:35.000Z",
                            "updated_at": "2019-05-15T11:10:35.000Z",
                            "question_id": 235,
                            "match": "",
                            "deleted_at": ""
                        ]
                    ],
                    "correction_style": "",
                    "type": "TrueOrFalse",
                    "bloom": [],
                    "files": "",
                    "uploaded_file": "",
                    "correct_answers_count": 1
                ]
            ],
            "objectives": [],
            "grouping_students": [],
            "course_groups_quiz": [
                [
                    "course_group_id": 516,
                    "quiz_id": 94,
                    "deleted_at": "",
                    "hide_grade": false,
                    "id": 158,
                    "select_all": true
                ],
                [
                    "course_group_id": 532,
                    "quiz_id": 94,
                    "deleted_at": "",
                    "hide_grade": false,
                    "id": 159,
                    "select_all": true
                ]
            ]
        ]
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
            if let question = questions.first as? Questions {
                cell.questionType = question.type.map { QuestionTypes(rawValue: $0) }!
            }
            return cell
        } else {
            if questions[indexPath.row] is String {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerLabelCell") as! QuizAnswerLabelTableViewCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as! QuizAnswerTableViewCell
                cell.answer = questions[indexPath.row] as? Answers
                if let question = questions.first as? Questions {
                    cell.questionType = question.type.map { QuestionTypes(rawValue: $0) }!
                }
                return cell
            }
        }
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    @available(iOS 11.0, *)
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if let destIndex = destinationIndexPath, destIndex.row < 2 {
            return UITableViewDropProposal(operation: .forbidden, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
        let destinationIndexPath: IndexPath
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
            guard let name = (items as? [String])?.first else { return }
            guard let oldIndex = self.answers.index(of: name) else { return }
            let newIndex = destinationIndexPath.row
            self.answers.swapAt(oldIndex, newIndex-2)
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        //should be disabled for questions and the answer cell
        if indexPath.row < 2 {
            return []
        } else {
            let string = answers[indexPath.row-2]
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
