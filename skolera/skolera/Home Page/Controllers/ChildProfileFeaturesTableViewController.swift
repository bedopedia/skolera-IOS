//
//  ChildProfileFeaturesTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/27/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import YLProgressBar
import DateToolsSwift
import NVActivityIndicatorView
import SkeletonView

class ChildProfileFeaturesTableViewController: UITableViewController, NVActivityIndicatorViewable, SkeletonTableViewDataSource {

    //MARK: - Outlets
    @IBOutlet weak var presentDaysLabel: UILabel!
    @IBOutlet weak var attendanceProgressBar: YLProgressBar!
    
    @IBOutlet weak var positiveBehaviorNotesLabel: UILabel!
    @IBOutlet weak var negativeBehaviorNotesLabel: UILabel!
    
    @IBOutlet weak var otherBehaviorNotesLabel: UILabel!
    //MARK: - Variables
    
    /// courses grades for this child, segued to grades screen
    var gradesCourses = [PostCourse]()
    var timeslots = [TimeSlot]()
    var weeklyPlans: [WeeklyPlan] = []
    var today: Date!
    var tomorrow: Date!
    /// Once set, get grades for this child
    var child : Child!{
        didSet{
            if child != nil{
                getBehaviorNotesCount()
                getTimeTable()
//                getWeeklyReport()
                let presentDays = child.attendances.filter({ attendance -> Bool in
                    return attendance.status == "present"
                }).count
                attendanceProgressBar.progress = CGFloat(presentDays) / CGFloat(child.attendances.count)
                if Language.language == .arabic {
                    presentDaysLabel.text = "حضور \(presentDays) من \(child.attendances.count) ايام"
                } else {
                    presentDaysLabel.text = "present \(presentDays) out of \(child.attendances.count) days"
                }
                setProgressBarColor(absentDays: child.attendances.count - presentDays)
            }
        }
    }
    
    var scrollHandler: ( (CGFloat) -> ())!
    
    func setProgressBarColor(absentDays: Int){
        switch absentDays {
        case ..<15:
            attendanceProgressBar.progressTintColors = [UIColor.appColors.green, UIColor.appColors.green]
        case 15...30:
            attendanceProgressBar.progressTintColors = [UIColor.appColors.orange, UIColor.appColors.orange]
        case 30...:
            attendanceProgressBar.progressTintColors = [UIColor.appColors.red, UIColor.appColors.red]
        default:
            attendanceProgressBar.progressTintColors = [UIColor.appColors.progressBarColor1,UIColor.appColors.progressBarColor2]
        }
    }
    
    var disableTimeTable: Bool = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProgressBarProperties()
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        tableView.register(UINib(nibName: "SkeletonTableViewCell", bundle: nil), forCellReuseIdentifier: "SkeletonTableViewCell")
        self.tableView.rowHeight = 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.hideSkeleton()
        switch cell?.reuseIdentifier{
        case "mainAttendanceCell":
            showAttendance()
        case "mainGradesCell":
            showCoursesGrades()
        case "mainTimetableCell":
            showTimetable()
        case "mainBehaviorNotesCell":
            showBehaviorNotes()
        case "mainWeeklyPlannerCell":
            showWeeklyPlanner()
        case "mainAssignmentsCell":
            openAssignments()
        case "mainPostsCell":
            openPosts()
        case "mainQuizzesCell":
            openQuizzes()
        case "mainCalendarCell":
            openCalendar()
        default:
            return
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SkeletonTableViewCell"
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        scrollHandler(y)
    }
    
    //MARK: - Methods
    /// set the progressBar colors, rounded corners
    fileprivate func setProgressBarProperties() {
        attendanceProgressBar.type = .rounded
        attendanceProgressBar.hideGloss = true
        attendanceProgressBar.progressStretch = true
        attendanceProgressBar.hideStripes = true
        attendanceProgressBar.trackTintColor = UIColor.appColors.progressBarBackgroundColor
        attendanceProgressBar.progressTintColors = [UIColor.appColors.progressBarColor1,UIColor.appColors.progressBarColor2]
    }
    
    private func openPosts(){
        let postsVC = PostsViewController.instantiate(fromAppStoryboard: .Posts)
        postsVC.child = self.child
        self.navigationController?.pushViewController(postsVC, animated: true)
    }
    
    private func openAssignments(){
        let assignmentsVC = AssignmentCoursesViewController.instantiate(fromAppStoryboard: .Assignments)
        assignmentsVC.child = self.child
        self.navigationController?.pushViewController(assignmentsVC, animated: true)
    }
    
    private func openQuizzes(){
        let quizVC = QuizzesCoursesViewController.instantiate(fromAppStoryboard: .Quizzes)
        quizVC.child = self.child
        
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
    
    private func openCalendar(){
        let eventsVC = EventsViewController.instantiate(fromAppStoryboard: .Events)
        eventsVC.child = self.child
        self.navigationController?.pushViewController(eventsVC, animated: true)
    }
    
//    MARK:- Network Calls

    private func getBehaviorNotesCount() {
//        self.tableView.showAnimatedSkeleton()
        let parameters : Parameters = ["student_id" : child.actableId,"user_type" : "Parents"]
        getBehaviourNotesCountAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.getTimeTable()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let behaviorNotesNumbersResponse = BehaviorNotesNumbersResponse.init(fromDictionary: result)
                    self.positiveBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.good!)"
                    self.negativeBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.bad!)"
                    self.otherBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.other!)"
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getTimeTable() {
        getTimeTableAPI(childActableId: child.actableId!) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]], result.count > 0 {
                    for timeslotDictionary in result {
                        let timeslot = TimeSlot.init(fromDictionary: timeslotDictionary)
                        timeslot.day.capitalizeFirstLetter()
                        self.timeslots.append(timeslot)
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en")
                    self.timeslots.sort(by: { (a, b) -> Bool in
                        if dateFormatter.weekdaySymbols.index(of: a.day)! == dateFormatter.weekdaySymbols.index(of: b.day)! {
                            return a.from.time < b.from.time
                        } else {
                            return dateFormatter.weekdaySymbols.index(of: a.day)! < dateFormatter.weekdaySymbols.index(of: b.day)!
                        }
                    })
                    dateFormatter.dateFormat = "EEEE"
                    let now = Date()
                    var next = self.timeslots.first(where: { (a) -> Bool in
                        return a.day == dateFormatter.string(from: now) && now.time < a.from.time
                    })
                    if next == nil {
                        if let lasttimeSlottoday = self.timeslots.filter({ (a) -> Bool in
                            return a.day == dateFormatter.string(from: now)
                        }).last {
                            next = self.timeslots[(self.timeslots.index(of: lasttimeSlottoday)! + 1) % self.timeslots.count]
                        }
                    }
                    if next == nil {
                        next = self.timeslots.first!
                    }
                    self.disableTimeTable = false
                } else {
                    self.disableTimeTable = true
                }
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                self.tableView.reloadData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    //    private func getCourseGroups() {
    //        getCourseGroupsAPI(childId: child.id!) { (isSuccess, statusCode, value, error) in
    //            self.stopAnimating()
    //            if isSuccess {
    //                if let result = value as? [[String : AnyObject]] {
    //                    var courseGroups = [Int: CourseGroup]()
    //                    for courseGroup in result{
    //                        let temp = CourseGroup.init(fromDictionary: courseGroup)
    //                        courseGroups[temp.courseId] = temp
    //                    }
    ////                    for grade in self.grades{
    ////                        grade.courseGroup = courseGroups[grade.courseId]
    ////                    }
    //                }
    //            } else {
    //                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
    //            }
    //        }
    //    }
        
    //MARK: - Actions
    
    /// move to grades screen to show courses grades
    func showCoursesGrades() {
        let gtvc = GradesListViewController.instantiate(fromAppStoryboard: .Grades)
        gtvc.child = child
//        gtvc.grades = self.gradesCourses
        self.navigationController?.pushViewController(gtvc, animated: true)
    }
    
    func showAttendance() {
        let avc = AttendanceViewController.instantiate(fromAppStoryboard: .Attendance)
        avc.child = child
        self.navigationController?.pushViewController(avc, animated: true)
    }
    
    func showBehaviorNotes() {
        let bvc = BehaviorNotesViewController.instantiate(fromAppStoryboard: .BehaviorNotes)
        bvc.child = child
        self.navigationController?.pushViewController(bvc, animated: true)
    }
    func showWeeklyPlanner() {
//        if !self.weeklyPlans.isEmpty {
            let wvc = WeeklyPlannerViewController.instantiate(fromAppStoryboard: .WeeklyReport)
            wvc.child = child
//            wvc.weeklyPlanner = self.weeklyPlans.first
            self.navigationController?.pushViewController(wvc, animated: true)
//        }
//    else {
//            let alert = UIAlertController(title: "Skolera", message: "No weekly planner available".localized, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
//            }))
//            alert.modalPresentationStyle = .fullScreen
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    func showTimetable() {
        today = Date().start(of: .day).add(TimeChunk.dateComponents(hours: 2))
        tomorrow = today.add(TimeChunk.dateComponents(days: 1))
        var flag = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let todayString = dateFormatter.string(from: today)
        let tomorrowString = dateFormatter.string(from: tomorrow)
        for slot in timeslots {
            if slot.day.localized.elementsEqual(todayString) || slot.day.localized.elementsEqual(tomorrowString) {
                flag = true
                break
            }
        }
        if !disableTimeTable {
            if flag {
                let ttvc = TimetableViewController.instantiate(fromAppStoryboard: .Timetable)
                ttvc.child = child
                ttvc.timeslots = timeslots
                self.navigationController?.pushViewController(ttvc, animated: true)
            } else {
                let alert = UIAlertController(title: "Skolera".localized, message: "No timetable available".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                alert.modalPresentationStyle = .fullScreen
                self.present(alert, animated: true, completion: nil)
            }
        
        } else {
            let alert = UIAlertController(title: "Skolera", message: "No timetable available".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
            }))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
}
