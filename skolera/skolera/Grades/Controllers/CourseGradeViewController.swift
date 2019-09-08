//
//  CourseGradeViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 4/12/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import YLProgressBar

class CourseGradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Outlets
    @IBOutlet weak var navbarTitleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var students: [Student] = []
    var assignAvg: [String: Double] = [:]
    var quizAvg: [String: Double] = [:]
    var gradeItemAvg: [String: Double] = [:]
    
    
    //MARK: - Variables
    var child : Child!
    var grade: CourseGrade!
    var courseGradingPeriods: [CourseGradingPeriods] = []
    var coursePeriods: [CourseGradingPeriods] = []
    var courseSubPeriods: [CourseGradingPeriods] = []
//    var semeters: [String: [AnyObject]] = [:]
    var semetersDic: [String: [AnyObject]] = [:]
    
    var currentSemester: String = ""
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        if let grade = grade{
            navbarTitleLabel.text = grade.name
        }
        
        getAvgStudentGrades()
        getCourseGradingPeriods()
//        getStudentGradeBook()
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            handleSemesters()
        } else {
            handleCurrentSemester()
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        refreshControl.beginRefreshing()
        getAvgStudentGrades()
        getCourseGradingPeriods()
//        getStudentGradeBook()
        refreshControl.endRefreshing()
    }
    
    private func getAvgStudentGrades(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = ["student_id" : child.actableId]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_STUDENT_GRADE_AVG(), grade.courseId, grade.courseGroup.id)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.popActivity()
            switch response.result{
            case .success(_):
                if let result = response.result.value as? [String : AnyObject] {
                    //can't be empty
                    self.assignAvg = (result["assignments_averages"] as! [String: Double])
                    self.quizAvg = (result["quizzes_averages"] as! [String: Double])
                    self.gradeItemAvg = (result["grades_averages"] as! [String: Double])
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 ||  response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    private func getStudentGradeBook(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = ["student_id" : child.actableId]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_STUDENT_GRADE_BOOK(), grade.courseId, grade.courseGroup.id)
        debugPrint(url)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.popActivity()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [String : AnyObject]
                {
                    let studentDic = (result["students"] as! [[String: AnyObject]])[0]
                    let assignmentsDic = studentDic["assignments"] as! [String: AnyObject]
                    var assignments: [Assignment] = []
                    // parse assignments
                    for assignJson in assignmentsDic { //for every key-value
                        var assignDic = assignJson.value as! [String: AnyObject]
                        debugPrint(assignDic)
                        assignments.append(Assignment(id: assignDic["id"] as! Int,
                                                      name: assignDic["name"] as! String,
                                                      total: assignDic["total"] as! Double,
                                                      grade: assignDic["grade"] as! Double,
                                                      gradeView: assignDic["grade_view"] as? String ?? "\(assignDic["grade_view"] as? Double ?? 0)",
                                                      feedback: assignDic["feedback"] as? String ?? "",
                                                      createdAt: assignDic["end_date"] as! String,
                                                      hideGrade: assignDic["hide_grade"] as? Bool ?? false))
                    }
                    // parse quizzes
                    let quizzesJson = studentDic["quizzes"] as! [String: AnyObject]
                    var quizzes: [Quiz] = []
                    for quizJson in quizzesJson {
                        var quizDic = quizJson.value as! [String: AnyObject]
                        debugPrint(quizDic)
                        quizzes.append(Quiz(id: quizDic["id"] as! Int,
                                            name: quizDic["name"] as! String,
                                            totalScore: quizDic["total_score"] as! Double,
                                            total: quizDic["total"] as! Double,
                                            grade: quizDic["grade"] as! Double,
                                            gradeView: quizDic["grade_view"] as? String ?? "\(quizDic["grade_view"] as? Double ?? 0)",
                                            feedback: quizDic["feedback"] as? String ?? "",
                                            createdAt: quizDic["end_date"] as! String,
                                            hideGrade: quizDic["hide_grade"] as? Bool ?? false))
                    }
                    // parse gradeItems
                    let gradeItemsJson = studentDic["grade_items"] as! [String: AnyObject]
                    var gradeItems: [GradeItem] = []
                    for gradeItemJson in gradeItemsJson {
                        debugPrint(gradeItemsJson)
                        var gradeItemDic = gradeItemJson.value as! [String: AnyObject]
                        gradeItems.append(GradeItem(id: gradeItemDic["id"] as! Int,
                                                    name: gradeItemDic["name"] as! String,
                                                    maxGrade: gradeItemDic["max_grade"] as! Int,
                                                    total: gradeItemDic["total"] as! Double,
                                                    grade: gradeItemDic["grade"] as! Double,
                                                    gradeView: gradeItemDic["grade_view"] as? String ?? "\(gradeItemDic["grade_view"] as? Double ?? 0)",
                                                    feedback: gradeItemDic["feedback"] as? String ?? "",
                                                    createdAt: gradeItemDic["end_date"] as! String,
                                                    periodId: gradeItemDic["grading_period_id"] as! Int,
                                                    hideGrade: gradeItemDic["hide_grade"] as? Bool ?? false))
                    }
                    
                    
                    self.students.append(Student(id: studentDic["id"] as! Int,
                                                name: studentDic["name"] as! String,
                                                userId: studentDic["user_id"] as! Int,
                                                assignments: assignments,
                                                quizzes: quizzes,
                                                gradeItems: gradeItems))
                    self.handleSemesters()
//                    self.tableView.reloadData()
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 ||  response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    private func getCourseGradingPeriods(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = ["course_id" : grade.courseId]
        debugPrint(grade.courseId)
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_COURSE_GRADING_PERIODS())
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.popActivity()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    debugPrint(response)
                    var courseGradingPeriods: [CourseGradingPeriods] = []
                    self.coursePeriods = []
                    for courseGroup in result{
                        let temp = CourseGradingPeriods.init(fromDictionary: courseGroup)
                        temp.subGradingPeriodsAttributes = []
                        self.coursePeriods.append(temp)
                        for subCourseGroup in courseGroup["sub_grading_periods_attributes"] as? [[String : AnyObject]] ?? [] {
                            let item = CourseGradingPeriods.init(fromDictionary: subCourseGroup)
                            item.isChild = true
                            item.subGradingPeriodsAttributes = []
                            temp.subGradingPeriodsAttributes.append(item)
                            self.coursePeriods.append(item)
                        }
                        courseGradingPeriods.append(temp)
                        
                    }
                    self.courseGradingPeriods = courseGradingPeriods
                    self.getStudentGradeBook()
//                    self.tableView.reloadData()
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 ||  response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    private func handleSemesters(){
        self.semetersDic = [:]
        for sem in self.courseGradingPeriods {
            self.semetersDic[sem.name] = []
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let semStartDate = dateFormatter.date(from: sem.startDate)
            let semEndDate = dateFormatter.date(from: sem.endDate)
            if sem.subGradingPeriodsAttributes.count > 0 {
                for subSem in sem.subGradingPeriodsAttributes {
                    self.semetersDic[subSem.name] = []
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let subSemStartDate = dateFormatter.date(from: subSem.startDate)
                    let subSemEndDate = dateFormatter.date(from: subSem.endDate)
                    for assign in self.students[0].assignments {
                        let assignDate = dateFormatter.date(from: assign.createdAt)
                        if assignDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                            self.semetersDic[subSem.name]?.append("Assignments".localized as AnyObject)
                            break
                        }
                    }
                    for assign in self.students[0].assignments {
                        let assignDate = dateFormatter.date(from: assign.createdAt)
                        if assignDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                            self.semetersDic[subSem.name]?.append(assign)
                        }
                    }
                    for quiz in self.students[0].quizzes {
                        let quizDate = dateFormatter.date(from: quiz.createdAt)
                        if quizDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                            self.semetersDic[subSem.name]?.append("Quizzes".localized as AnyObject)
                            break
                        }
                    }
                    for quiz in self.students[0].quizzes {
                        let quizDate = dateFormatter.date(from: quiz.createdAt)
                        if quizDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                            self.semetersDic[subSem.name]?.append(quiz)
                        }
                    }
                    for gradeItem in self.students[0].gradeItems {
                        if gradeItem.periodId == subSem.id {
                            self.semetersDic[subSem.name]?.append("Grade Items".localized as AnyObject)
                            break
                        }
                    }
                    for gradeItem in self.students[0].gradeItems {
                        if gradeItem.periodId == subSem.id {
                            self.semetersDic[subSem.name]?.append(gradeItem)
                        }
                    }
                }
            } else {
                for assign in self.students[0].assignments {
                    let assignDate = dateFormatter.date(from: assign.createdAt)
                    if assignDate!.isBetween(semStartDate!, and: semEndDate!) {
                        self.semetersDic[sem.name]?.append("Assignments".localized as AnyObject)
                        break
                    }
                }
                for assign in self.students[0].assignments {
                    let assignDate = dateFormatter.date(from: assign.createdAt)
                    if assignDate!.isBetween(semStartDate!, and: semEndDate!) {
                        self.semetersDic[sem.name]?.append(assign)
                    }
                }
                for quiz in self.students[0].quizzes {
                    let quizDate = dateFormatter.date(from: quiz.createdAt)
                    if quizDate!.isBetween(semStartDate!, and: semEndDate!) {
                        self.semetersDic[sem.name]?.append("Quizzes".localized as AnyObject)
                        break
                    }
                }
                for quiz in self.students[0].quizzes {
                    let quizDate = dateFormatter.date(from: quiz.createdAt)
                    if quizDate!.isBetween(semStartDate!, and: semEndDate!) {
                        self.semetersDic[sem.name]?.append(quiz)
                    }
                }
                for gradeItem in self.students[0].gradeItems {
                    if gradeItem.periodId == sem.id {
                        self.semetersDic[sem.name]?.append("Grade Items".localized as AnyObject)
                        break
                    }
                }
                for gradeItem in self.students[0].gradeItems {
                    if gradeItem.periodId == sem.id {
                        self.semetersDic[sem.name]?.append(gradeItem)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    private func handleCurrentSemester(){
        self.semetersDic = [:]
        self.courseSubPeriods = []
        for sem in self.courseGradingPeriods {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let semStartDate = dateFormatter.date(from: sem.startDate)
            let semEndDate = dateFormatter.date(from: sem.endDate)
            if Date().isBetween(semStartDate!, and: semEndDate!) {
                self.semetersDic[sem.name] = []
                if sem.subGradingPeriodsAttributes.count > 0 {
                    for subSem in sem.subGradingPeriodsAttributes {
                        courseSubPeriods.append(subSem)
                        self.semetersDic[subSem.name] = []
                        self.currentSemester = sem.name
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en")
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let subSemStartDate = dateFormatter.date(from: subSem.startDate)
                        let subSemEndDate = dateFormatter.date(from: subSem.endDate)
                        for assign in self.students[0].assignments {
                            let assignDate = dateFormatter.date(from: assign.createdAt)
                            if assignDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                                self.semetersDic[subSem.name]?.append("Assignments".localized as AnyObject)
                                break
                            }
                        }
                        for assign in self.students[0].assignments {
                            let assignDate = dateFormatter.date(from: assign.createdAt)
                            if assignDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                                self.semetersDic[subSem.name]?.append(assign)
                            }
                        }
                        for quiz in self.students[0].quizzes {
                            let quizDate = dateFormatter.date(from: quiz.createdAt)
                            if quizDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                                self.semetersDic[subSem.name]?.append("Quizzes".localized as AnyObject)
                                break
                            }
                        }
                        for quiz in self.students[0].quizzes {
                            let quizDate = dateFormatter.date(from: quiz.createdAt)
                            if quizDate!.isBetween(subSemStartDate!, and: subSemEndDate!) {
                                self.semetersDic[subSem.name]?.append(quiz)
                            }
                        }
                        for gradeItem in self.students[0].gradeItems {
                            if gradeItem.periodId == subSem.id {
                                self.semetersDic[subSem.name]?.append("Grade Items".localized as AnyObject)
                                break
                            }
                        }
                        for gradeItem in self.students[0].gradeItems {
                            if gradeItem.periodId == subSem.id {
                                self.semetersDic[subSem.name]?.append(gradeItem)
                            }
                        }
                    }
                } else {
                    for assign in self.students[0].assignments {
                        let assignDate = dateFormatter.date(from: assign.createdAt)
                        if assignDate!.isBetween(semStartDate!, and: semEndDate!) {
                            self.semetersDic[sem.name]?.append("Assignments".localized as AnyObject)
                            break
                        }
                    }
                    for assign in self.students[0].assignments {
                        let assignDate = dateFormatter.date(from: assign.createdAt)
                        if assignDate!.isBetween(semStartDate!, and: semEndDate!) {
                            self.semetersDic[sem.name]?.append(assign)
                        }
                    }
                    for quiz in self.students[0].quizzes {
                        let quizDate = dateFormatter.date(from: quiz.createdAt)
                        if quizDate!.isBetween(semStartDate!, and: semEndDate!) {
                            self.semetersDic[sem.name]?.append("Quizzes".localized as AnyObject)
                            break
                        }
                    }
                    for quiz in self.students[0].quizzes {
                        let quizDate = dateFormatter.date(from: quiz.createdAt)
                        if quizDate!.isBetween(semStartDate!, and: semEndDate!) {
                            self.semetersDic[sem.name]?.append(quiz)
                        }
                    }
                    for gradeItem in self.students[0].gradeItems {
                        if gradeItem.periodId == sem.id {
                            self.semetersDic[sem.name]?.append("Grade Items".localized as AnyObject)
                            break
                        }
                    }
                    for gradeItem in self.students[0].gradeItems {
                        if gradeItem.periodId == sem.id {
                            self.semetersDic[sem.name]?.append(gradeItem)
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentControl.selectedSegmentIndex == 1 {
            return courseSubPeriods.count
        } else {
            return self.coursePeriods.count
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segmentControl.selectedSegmentIndex == 1 {
            if courseSubPeriods.isEmpty {
                return 0
            } else {
                return 32
            }
        } else {
            return 32
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 1 {
            return (self.semetersDic[courseSubPeriods[section].name]?.count) ?? 0
        } else {
            return (self.semetersDic[coursePeriods[section].name]?.count) ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if segmentControl.selectedSegmentIndex == 1 {
            if courseSubPeriods.isEmpty {
                return ""
            } else {
                return courseSubPeriods[section].name
            }
        } else {
            return coursePeriods[section].name
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item:AnyObject?
        var title: String = ""
        var publish = true
        if segmentControl.selectedSegmentIndex == 1 {
            item = semetersDic[courseSubPeriods[indexPath.section].name]![indexPath.row]
            title = self.courseSubPeriods[indexPath.section].name
            publish = self.courseSubPeriods[indexPath.section].publish
        } else {
            item = semetersDic[coursePeriods[indexPath.section].name]![indexPath.row]
            title = self.coursePeriods[indexPath.section].name
            publish = self.coursePeriods[indexPath.section].publish
        }
        
        
        
        if item is String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeHeaderTableViewCell", for: indexPath as IndexPath) as! GradeHeaderTableViewCell
            cell.selectionStyle = .none
            cell.titleNameLabel.text = item as? String
            if (item as! String).elementsEqual("Assignments") {
                var grade: Double = 0
                var totGrade: Double = 0
                for i in self.semetersDic[title]! {
                    if i is Assignment {
                        grade += round2Digits((i as! Assignment).grade)
                        totGrade += round2Digits((i as! Assignment).total)
                    }
                }
                if totGrade > 0 && publish{
                    cell.gradeLabel.text = "\(grade)"
                    cell.totalGradeLabel.text = Language.language == .arabic ? "\(totGrade)/" : "/\(totGrade)"
                } else {
                    cell.gradeLabel.text = ""
                    cell.totalGradeLabel.text = ""
                }
            } else if (item as! String).elementsEqual("Quizzes"){
                var grade: Double = 0
                var totGrade: Double = 0
                for i in self.semetersDic[title]! {
                    if i is Quiz {
                        grade += round2Digits((i as! Quiz).grade)
                        totGrade += round2Digits((i as! Quiz).total)
                    }
                }
                if totGrade > 0 && publish{
                    cell.gradeLabel.text = "\(grade)"
                    cell.totalGradeLabel.text = Language.language == .arabic ? "\(totGrade)/" : "/\(totGrade)"
                } else {
                    cell.gradeLabel.text = ""
                    cell.totalGradeLabel.text = ""
                }
            } else {
                var grade: Double = 0
                var totGrade: Double = 0
                for i in self.semetersDic[title]! {
                    if i is GradeItem {
                        grade += round2Digits((i as! GradeItem).grade)
                        totGrade += round2Digits((i as! GradeItem).total)
                    }
                }
                if totGrade > 0 && publish{
                    cell.gradeLabel.text = "\(grade)"
                    cell.totalGradeLabel.text = Language.language == .arabic ? "\(totGrade)/" : "/\(totGrade)"
                } else {
                    cell.gradeLabel.text = ""
                    cell.totalGradeLabel.text = ""
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeDetailTableViewCell", for: indexPath as IndexPath) as! GradeDetailTableViewCell
            cell.selectionStyle = .none
            if item is Assignment {
                cell.TitleLabel.text = (item as! Assignment).name
                cell.avgGradeLabel.text = ""
                if (item as! Assignment).hideGrade {
                    cell.gradeLabel.text = "****"
                } else {
                    cell.gradeLabel.text = "\(round2Digits((item as! Assignment).grade))/\(round2Digits((item as! Assignment).total))"
                }
                
                cell.gradeWorldLabel.text = (item as! Assignment).feedback
                if Language.language == .arabic {
                    cell.avgGradeLabel.text = "الدرجه المتوسطه \(round2Digits(self.assignAvg["\((item as! Assignment).id)"] ?? (item as! Assignment).grade))"
                } else {
                    cell.avgGradeLabel.text = "Avg. grade is \(round2Digits(self.assignAvg["\((item as! Assignment).id)"] ?? (item as! Assignment).grade))"
                }
                
            } else if item is Quiz {
                cell.TitleLabel.text = (item as! Quiz).name
                cell.avgGradeLabel.text = ""
                if (item as! Quiz).hideGrade {
                    cell.gradeLabel.text = "****"
                } else {
                    cell.gradeLabel.text = "\(round2Digits((item as! Quiz).grade))/\(round2Digits((item as! Quiz).total))"
                }
                
                cell.gradeWorldLabel.text = (item as! Quiz).feedback
                if Language.language == .arabic {
                    cell.avgGradeLabel.text = "الدرجه المتوسطه\(round2Digits(self.quizAvg["\((item as! Quiz).id)"] ?? (item as! Quiz).grade))"
                } else {
                    cell.avgGradeLabel.text = "Avg. grade is \(round2Digits(self.quizAvg["\((item as! Quiz).id)"] ?? (item as! Quiz).grade))"
                }
                
            } else if item is GradeItem {
                cell.TitleLabel.text = (item as! GradeItem).name
                cell.avgGradeLabel.text = ""
                if (item as! GradeItem).hideGrade {
                    cell.gradeLabel.text = "****"
                } else {
                    cell.gradeLabel.text = "\(round2Digits((item as! GradeItem).grade))/\(round2Digits((item as! GradeItem).total))"
                }
                cell.gradeWorldLabel.text = (item as! GradeItem).feedback
                
                if Language.language == .arabic {
                    cell.avgGradeLabel.text = "الدرجة المتوسطه \(Int(self.gradeItemAvg["\((item as! GradeItem).id)"] ?? (item as! GradeItem).grade))"
                } else {
                    cell.avgGradeLabel.text = "Avg. grade is \(Int(self.gradeItemAvg["\((item as! GradeItem).id)"] ?? (item as! GradeItem).grade))"
                }
            }
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var item:AnyObject?
        if segmentControl.selectedSegmentIndex == 1 {
            item = semetersDic[courseSubPeriods[indexPath.section].name]![indexPath.row]
        } else {
            item = self.semetersDic[self.coursePeriods[indexPath.section].name]![indexPath.row]
        }
        if item is String {
            return 40
        } else {
            return 71.5
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func round2Digits(_ double: Double) -> Double {
        let multiplier = pow(10, Double(2))
        return Darwin.round(double * multiplier) / multiplier
        
    }

}
