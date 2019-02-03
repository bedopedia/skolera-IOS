//
//  ChildProfileFeaturesTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/27/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import YLProgressBar
class ChildProfileFeaturesTableViewController: UITableViewController {

    //MARK: - Outlets
    @IBOutlet weak var averageGradeLabel: UILabel!
    
    @IBOutlet weak var presentDaysLabel: UILabel!
    @IBOutlet weak var attendanceProgressBar: YLProgressBar!
    @IBOutlet weak var timetableLabel: UILabel!
    
    @IBOutlet weak var positiveBehaviorNotesLabel: UILabel!
    @IBOutlet weak var negativeBehaviorNotesLabel: UILabel!
    
    @IBOutlet weak var otherBehaviorNotesLabel: UILabel!
    //MARK: - Variables
    
    /// courses grades for this child, segued to grades screen
    var grades = [CourseGrade]()
    var timeslots = [TimeSlot]()
    /// Once set, get grades for this child
    var child : Child!{
        didSet{
            if child != nil{
                getGrades()
                getBehaviorNotesCount()
                getTimeTable()
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
        tableView.separatorStyle = .none
//        tableView.isScrollEnabled = false
        SVProgressHUD.setDefaultMaskType(.clear)
        setProgressBarProperties()
        
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
        default:
            return
        }
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
    
    /// service call to get total courses grades, average grade is set on completion
    private func getGrades()
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_GRADES(),child.actableId!)
        debugPrint(userId())
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let res = response.result.value as? [String : AnyObject]
                {
//                    debugPrint(res)
                    let result = res["courses_grades"] as! [[String: AnyObject]]
                    debugPrint(result)
                    for grade in result
                    {
                        var gradeItem = CourseGrade.init(fromDictionary: grade)
                        let gradeingPeriods = grade["grading_periods_grades"] as! [[String: AnyObject]]
                        var hideGrade: Bool = false
                        for item in  gradeingPeriods{
                            if let publish = item["publish"] as? Bool, publish {
                                debugPrint("PIBLISH", publish)
                                hideGrade = false
                            } else {
                                hideGrade = true
                                break
                            }
                            
                        }
                        gradeItem.hideGrade = hideGrade
                        self.grades.append(gradeItem)
                    }
                    
                    self.averageGradeLabel.text = "\(self.averageGradeLabel.text!) \(res["grade"]!["letter"]! ?? "-")"
                    print("finished grades")
                    self.getCourseGroups()
                    
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
    private func getCourseGroups()
    {
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_COURSE_GROUPS(),child.id!)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.popActivity()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    debugPrint(result)
                    var courseGroups = [Int: CourseGroup]()
                    
                    for courseGroup in result{
                        let temp = CourseGroup.init(fromDictionary: courseGroup)
                        courseGroups[temp.courseId] = temp
                    }
                    debugPrint(courseGroups)
                    for grade in self.grades{
                        grade.courseGroup = courseGroups[grade.courseId]
                    }
                    print("finished course groups")
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
    
    private func getBehaviorNotesCount()
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = ["student_id" : child.actableId,"user_type" : "Parents"]
        let headers : HTTPHeaders? = getHeaders()
        let url = GET_BEHAVIOR_NOTES_COUNT()
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let result = response.result.value as? [String : AnyObject]
                {
                    let behaviorNotesNumbersResponse = BehaviorNotesNumbersResponse.init(fromDictionary: result)
                    self.positiveBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.good!)"
                    self.negativeBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.bad!)"
                    self.otherBehaviorNotesLabel.text = "\(behaviorNotesNumbersResponse.other!)"
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
    private func getTimeTable()
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_TIME_TABLE(),child.actableId!)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                debugPrint(response)
                if let result = response.result.value as? [[String : AnyObject]], result.count > 0
                {
                    for timeslotDictionary in result
                    {
                        let timeslot = TimeSlot.init(fromDictionary: timeslotDictionary)
                        //next line is important so that we can sort by weekdays
                        timeslot.day.capitalizeFirstLetter()
                        self.timeslots.append(timeslot)
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale.init(identifier: "en")
                    //sort timeslots according to day variable first, and then by from variable
                    self.timeslots.sort(by: { (a, b) -> Bool in
                        if dateFormatter.weekdaySymbols.index(of: a.day)! == dateFormatter.weekdaySymbols.index(of: b.day)!
                        {
                           return a.from.time < b.from.time
                        }
                        else
                        {
                            return dateFormatter.weekdaySymbols.index(of: a.day)! < dateFormatter.weekdaySymbols.index(of: b.day)!
                        }
                    })
                    dateFormatter.dateFormat = "EEEE"
                    let now = Date()
                    var next = self.timeslots.first(where: { (a) -> Bool in
                        return a.day == dateFormatter.string(from: now) && now.time < a.from.time
                    })
                    if next == nil
                    {
                        if let lasttimeSlottoday = self.timeslots.filter({ (a) -> Bool in
                            return a.day == dateFormatter.string(from: now)
                        }).last
                        {
                            next = self.timeslots[(self.timeslots.index(of: lasttimeSlottoday)! + 1) % self.timeslots.count]
                        }
                    }
                    if next == nil
                    {
                        next = self.timeslots.first!
                    }
                        dateFormatter.dateFormat = "HH:mm a"
                    if Language.language == .arabic {
                        self.timetableLabel.text = "التالي: \((next?.courseName!)!), \((next?.day)!) \(dateFormatter.string(from: (next?.from)!))"
                    } else {
                        self.timetableLabel.text = "Next: \((next?.courseName!)!), \((next?.day)!) \(dateFormatter.string(from: (next?.from)!))"
                    }
                    

                    self.disableTimeTable = false
                    
                } else {
                    self.disableTimeTable = true
                    self.timetableLabel.text = Language.language == .arabic ? "لا يوجد جدول مواعيد" : "There is no timetable"
                    
                }
                SVProgressHUD.popActivity()
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
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion : nil)
                }
            }
        }
    }
    //MARK: - Actions
    
    /// move to grades screen to show courses grades
    func showCoursesGrades()
    {
        let gtvc = GradesTableViewController.instantiate(fromAppStoryboard: .Grades)
        gtvc.child = child
        gtvc.grades = self.grades
        self.navigationController?.pushViewController(gtvc, animated: true)
    }
    
    func showAttendance()
    {
        let avc = AttendanceViewController.instantiate(fromAppStoryboard: .Attendance)
        avc.child = child
        self.navigationController?.pushViewController(avc, animated: true)
    }
    
    func showBehaviorNotes()
    {
        let bvc = BehaviorNotesViewController.instantiate(fromAppStoryboard: .BehaviorNotes)
        bvc.child = child
        self.navigationController?.pushViewController(bvc, animated: true)
    }
    func showTimetable()
    {
        if !disableTimeTable {
            let ttvc = TimetableViewController.instantiate(fromAppStoryboard: .Timetable)
            ttvc.child = child
            ttvc.timeslots = timeslots
            self.navigationController?.pushViewController(ttvc, animated: true)
        }
    }
}
