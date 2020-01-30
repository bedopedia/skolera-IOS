//
//  CourseGradeViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 4/12/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import YLProgressBar

class CourseGradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    //MARK: - Outlets
    @IBOutlet weak var navbarTitleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var placeholderLabel: UILabel!
    
    
    //MARK: - Variables
    var child : Child!
    var grade: ShortCourseGroup!
    var courseGradingPeriods: [GradingPeriod] = []
    var semestersDic: [String: [AnyObject]] = [:]
    var semesterTitles: [String] = []
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child {
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        if let grade = grade {
            navbarTitleLabel.text = grade.courseName
        }
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        segmentControl.setTitleTextAttributes([.foregroundColor: getMainColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        segmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        if isParent() {
            if #available(iOS 13.0, *) {
                segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            } else {
                segmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            }
        } else {
            if #available(iOS 13.0, *) {
                segmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
            } else {
                segmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
            }
        }
        
        getStudentGradeBook()
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
            handelSemesters()
        } else {
            handleCurrentSemester()
        }
        checkData()
    }
    
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getStudentGradeBook()
        refreshControl.endRefreshing()
    }
    
    private func getStudentGradeBook() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getStudentGradeBookApi(childId: child.actableId, gradeSubject: grade) { (isSuccess, statusCode, response, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = response as? [String : AnyObject] {
                    let gradingPeriods = result["grading_periods"] as! [[String: AnyObject]]
                    self.courseGradingPeriods = gradingPeriods.map({ GradingPeriod($0)})
                    self.segmentControl.selectedSegmentIndex == 0 ? self.handelSemesters() : self.handleCurrentSemester()
                    self.tableView.reloadData()
                }
            } else {
                if statusCode == 403 {
                    showAlert(viewController: self, title: "Skolera", message: "Sorry, but you're not authorized to view this page".localized, completion: { action in
                        self.back()
                    })
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        }
        
    }
    
    private func handelSemesters(){
        self.semestersDic = [:]
        self.semesterTitles = []
        for semester in self.courseGradingPeriods {
            if let semesterName = semester.name {
                self.semesterTitles.append(semesterName)
                self.semestersDic[semesterName] = []
                if let mySubGradingPeriod = semester.subGradingPeriods, mySubGradingPeriod.count > 0 {
                    for subSemester in mySubGradingPeriod {
                        if let subSemesterName = subSemester.name {
                            self.semestersDic[subSemesterName] = []
                            self.semesterTitles.append(subSemesterName)
                            if let subSemesterAssignments = subSemester.assignments, subSemesterAssignments.count > 0 {
                                semestersDic[subSemesterName]?.append("Assignments".localized as AnyObject)
                                semestersDic[subSemesterName]?.append(contentsOf: subSemesterAssignments)
                            }
                            if let subSemesterQuizzes = subSemester.quizzes, subSemesterQuizzes.count > 0 {
                                semestersDic[subSemesterName]?.append("Quizzes".localized as AnyObject)
                                semestersDic[subSemesterName]?.append(contentsOf: subSemesterQuizzes)
                            }
                            if let subSemesterGradeItems = subSemester.gradeItems, subSemesterGradeItems.count > 0 {
                                semestersDic[subSemesterName]?.append("Grade Items".localized as AnyObject)
                                semestersDic[subSemesterName]?.append(contentsOf: subSemesterGradeItems)
                            }
                        }
                    }
                } else {
                    if let semesterAssignments = semester.assignments, semesterAssignments.count > 0 {
                        semestersDic[semesterName]?.append("Assignments".localized as AnyObject)
                        semestersDic[semesterName]?.append(contentsOf: semesterAssignments)
                    }
                    if let semesterQuizzes = semester.quizzes, semesterQuizzes.count > 0 {
                        semestersDic[semesterName]?.append("Quizzes".localized as AnyObject)
                        semestersDic[semesterName]?.append(contentsOf: semesterQuizzes)
                    }
                    if let semesterGradeItems = semester.gradeItems, semesterGradeItems.count > 0 {
                        semestersDic[semesterName]?.append("Grade Items".localized as AnyObject)
                        semestersDic[semesterName]?.append(contentsOf: semesterGradeItems)
                    }
                }
                
            }
        }
        checkData()
        tableView.reloadData()
    }
    
    private func handleCurrentSemester() {
        self.semestersDic = [:]
        self.semesterTitles = []
        for semester in self.courseGradingPeriods {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let semStartDate = dateFormatter.date(from: semester.startDate ?? "")
            let semEndDate = dateFormatter.date(from: semester.endDate ?? "")
            if Date().isBetween(semStartDate!, and: semEndDate!) {
                if let semseterName = semester.name {
                    if let mySubGradingPeriod = semester.subGradingPeriods, mySubGradingPeriod.count > 0  {
                        self.semesterTitles.append(semseterName)
                        self.semestersDic[semseterName] = []
                        for subSemester in mySubGradingPeriod {
                            let subSemStartDate = dateFormatter.date(from: subSemester.startDate ?? "")
                            let subSemEndDate = dateFormatter.date(from: subSemester.endDate ?? "")
                            if Date().isBetween(subSemStartDate!, and: subSemEndDate!) {
                                if let subSemesterName = subSemester.name {
                                    self.semesterTitles.append(subSemesterName)
                                    self.semestersDic[subSemesterName] = []
                                    if let subSemesterAssignments = subSemester.assignments, subSemesterAssignments.count > 0 {
                                        semestersDic[subSemesterName]?.append("Assignments".localized as AnyObject)
                                        semestersDic[subSemesterName]?.append(contentsOf: subSemesterAssignments)
                                    }
                                    if let subSemesterQuizzes = subSemester.quizzes, subSemesterQuizzes.count > 0 {
                                        semestersDic[subSemesterName]?.append("Quizzes".localized as AnyObject)
                                        semestersDic[subSemesterName]?.append(contentsOf: subSemesterQuizzes)
                                    }
                                    if let subSemesterGradeItems = subSemester.gradeItems, subSemesterGradeItems.count > 0 {
                                        semestersDic[subSemesterName]?.append("Grade Items".localized as AnyObject)
                                        semestersDic[subSemesterName]?.append(contentsOf: subSemesterGradeItems)
                                    }
                                }
                            }
                        }
                    } else {
                        self.semesterTitles.append(semseterName)
                        self.semestersDic[semseterName] = []
                        if let semesterAssignments = semester.assignments, semesterAssignments.count > 0 {
                            semestersDic[semseterName]?.append("Assignments".localized as AnyObject)
                            semestersDic[semester.name ?? ""]?.append(contentsOf: semesterAssignments)
                        }
                        if let semesterQuizzes = semester.quizzes, semesterQuizzes.count > 0 {
                            semestersDic[semseterName]?.append("Quizzes".localized as AnyObject)
                            semestersDic[semseterName]?.append(contentsOf: semesterQuizzes)
                        }
                        if let semesterGradeItems = semester.gradeItems, semesterGradeItems.count > 0{
                            semestersDic[semseterName]?.append("Grade Items".localized as AnyObject)
                            semestersDic[semseterName]?.append(contentsOf: semesterGradeItems)
                        }
                    }
                }
            }
            
        }
        
        tableView.reloadData()
    }
    
    
    fileprivate func checkSemesterDict() {
        var isEmptyFlag = true
        let keys = semestersDic.keys
        for key in keys {
            if semestersDic[key]!.count > 0 {
                isEmptyFlag = false
                break
            }
        }
        if isEmptyFlag {
            placeholderView.isHidden = false
        } else {
            placeholderView.isHidden = true
        }
    }
    
    func checkData() {
        if segmentControl.selectedSegmentIndex == 0 {
            placeholderLabel.text = "You don't have any grades for now".localized
            if semesterTitles.count == 0 {
                placeholderView.isHidden = false
            } else {
                checkSemesterDict()
            }
        } else {
            placeholderLabel.text = "You don't have any current grades for now".localized
            if semesterTitles.count == 0 {
                placeholderView.isHidden = false
            } else {
                checkSemesterDict()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.semesterTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if segmentControl.selectedSegmentIndex == 1 {
            if semesterTitles.isEmpty {
                return 0
            } else {
                return 32
            }
        } else {
            return 32
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let semesterData = semestersDic[semesterTitles[section]]{
            return semesterData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return semesterTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item:AnyObject?
        if let semesterData = semestersDic[semesterTitles[indexPath.section]]{
            item = semesterData[indexPath.row]
        }
        
        if item is String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeHeaderTableViewCell", for: indexPath as IndexPath) as! GradeHeaderTableViewCell
            cell.selectionStyle = .none
            cell.titleNameLabel.text = item as? String
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeDetailTableViewCell", for: indexPath as IndexPath) as! GradeDetailTableViewCell
            cell.selectionStyle = .none
            if item is StudentGrade {
                let assignment = item as! StudentGrade
                cell.TitleLabel.text = assignment.name
                cell.avgGradeLabel.text = ""
                let mGradeView = assignment.gradeView.replacingOccurrences(of: ".0", with: "")
                if (assignment.total - floor(assignment.total) > 0.000001) {
                    cell.gradeLabel.text = "\(mGradeView) / \(assignment.total)"
                } else {
                    cell.gradeLabel.text = "\(mGradeView) / \(Int(assignment.total))"
                }
                cell.gradeWorldLabel.text = ""
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var item:AnyObject?
        if  let semesterData = semestersDic[semesterTitles[indexPath.section]]{
            item = semesterData[indexPath.row]
        }
        
        if item is String {
            return 40
        } else {
            return 71.5
        }
    }
    
    func round2Digits(_ double: Double) -> Double {
        let multiplier = pow(10, Double(2))
        return Darwin.round(double * multiplier) / multiplier
    }
    
}
