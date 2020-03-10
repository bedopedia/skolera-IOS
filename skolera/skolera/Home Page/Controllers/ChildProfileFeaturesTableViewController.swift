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
    @IBOutlet weak var weeklyPlannerDateLabel: UILabel!
    
    @IBOutlet weak var attendanceImage: UIImageView!
    
    
    //MARK: - Variables
    
    /// courses grades for this child, segued to grades screen
    var gradesSubjects = [ShortCourseGroup]()
    var timeslots = [TimeSlot]()
    var weeklyPlan: [WeeklyPlan] = []
    var weeklyPlannerDates: [String] = []
    var today: Date!
    var tomorrow: Date!
    var shouldOpenBehaviorNotes: Bool = false
    /// Once set, get grades for this child
    var child : Actor!{
        didSet{
            if child != nil{
                getGradesSubjects()
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
//                self.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
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
    
    private func getDateByName(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "EEE dd/MM"
        return dateFormatter.string(from: date)
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
    
    /// service call to get total courses grades, average grade is set on completion
    private func getGradesSubjects() {
        self.tableView.showAnimatedSkeleton()
        getCourseGroupShortListApi(childId: child.childId!) { (isSuccess, statusCode, value, error) in
            self.getBehaviorNotesCount()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.gradesSubjects = result.map({ ShortCourseGroup($0)})
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getCourseGroups() {
        getCourseGroupsAPI(childId: child.id!) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    var courseGroups = [Int: CourseGroup]()
                    for courseGroup in result{
                        let temp = CourseGroup.init(fromDictionary: courseGroup)
                        courseGroups[temp.courseId] = temp
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getBehaviorNotesCount() {
        getBehaviourNotesCountAPI() { (isSuccess, statusCode, value, error) in
            self.getTimeTable()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let behaviorNotesNumbersResponse = BehaviorNotesNumbersResponse.init(fromDictionary: result)
                    self.positiveBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.good!)"
                    self.negativeBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.bad!)"
                    self.otherBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.other!)"
                    let good: Int = (behaviorNotesNumbersResponse.good ?? 0)
                    let bad: Int = (behaviorNotesNumbersResponse.bad ?? 0)
                    let other: Int = (behaviorNotesNumbersResponse.other ?? 0)
                    let total = good + bad + other
                    if total == 0 {
                        self.shouldOpenBehaviorNotes = false
                    } else {
                        self.shouldOpenBehaviorNotes = true
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getWeeklyPlanner() {
        getWeeklyPlansAPI() { (isSuccess, statusCode, value, error) in
            self.getAttendancesCount()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let weeklyPlanResponse = WeeklyPlanResponse(result)
                    if !weeklyPlanResponse.weeklyPlan.isEmpty {
                        self.weeklyPlan = weeklyPlanResponse.weeklyPlan
                        if Language.language == .arabic {
                            self.weeklyPlannerDateLabel.text = "تبدأ من \(self.getDateByName(date: self.weeklyPlan.first!.startDate)) إلى \(self.getDateByName(date: self.weeklyPlan.first!.endDate))"
                        } else {
                            self.weeklyPlannerDateLabel.text = "Starts from \(self.getDateByName(date: self.weeklyPlan.first!.startDate)) to \(self.getDateByName(date: self.weeklyPlan.first!.endDate))"
                        }
                    } else {
                        self.weeklyPlannerDateLabel.text = "No Weekly Planner available".localized
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getTimeTable() {
        getTimeTableAPI(childActableId: child.childId!) { (isSuccess, statusCode, value, error) in
            self.getWeeklyPlanner()
            if isSuccess {
                if let result = value as? [[String : AnyObject]], result.count > 0 {
                    self.timeslots = []
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
//                self.tableView.reloadData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func getAttendancesCount() {
        getAttendancesCountAPI(childId: child.childId!) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [String: Any], let presentCount = result["present_count"] as? Int, let total = result["total"] as? Int  {
                    DispatchQueue.main.async {
                        self.attendanceProgressBar.progress = CGFloat(presentCount) / CGFloat(total)
                        if Language.language == .arabic {
                            self.presentDaysLabel.text = "حضور \(presentCount) من \(total) ايام"
                        } else {
                            self.presentDaysLabel.text = "present \(presentCount) out of \(total) days"
                        }
                        self.setProgressBarColor(absentDays: total - presentCount)
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    
    //MARK: - Actions
    
    /// move to grades screen to show courses grades
    func showCoursesGrades() {
        let gtvc = GradesListViewController.instantiate(fromAppStoryboard: .Grades)
        gtvc.child = child
        gtvc.courseGroups = self.gradesSubjects
        self.navigationController?.pushViewController(gtvc, animated: true)
    }
    
    func showAttendance() {
        let avc = AttendanceViewController.instantiate(fromAppStoryboard: .Attendance)
        avc.child = child
        self.navigationController?.pushViewController(avc, animated: true)
    }
    
    func showBehaviorNotes() {
        if shouldOpenBehaviorNotes {
            let bvc = BehaviorNotesViewController.instantiate(fromAppStoryboard: .BehaviorNotes)
            bvc.child = child
            self.navigationController?.pushViewController(bvc, animated: true)
        } else {
            let alert = UIAlertController(title: "Skolera", message: "No behavior Notes Avaliable".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
            }))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showWeeklyPlanner() {
        let wvc = WeeklyPlannerViewController.instantiate(fromAppStoryboard: .WeeklyReport)
        wvc.child = child
        wvc.weeklyPlanner = self.weeklyPlan.first
        self.navigationController?.pushViewController(wvc, animated: true)
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
