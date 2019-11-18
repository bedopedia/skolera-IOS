//
//  TeacherAttendanceViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/1/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class TeacherAttendanceViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullDayAttendanceButton: UIButton!
    @IBOutlet weak var fullDayAttendanceBottomBorder: UIView!
    @IBOutlet weak var slotAttendanceBottomBar: UIView!
    @IBOutlet weak var slotAttendanceButton: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var assignForAllButton: UIButton!
    @IBOutlet weak var calendarImageView: UIImageView!
    @IBOutlet var placeholderView: UIView!
    
    var courseGroupId: Int!
    var timeTableSlots: [TimetableSlots]!
    var day = Date().day
    var month = Date().month
    var year = Date().year
    var isFullDay: Bool!
    var selectedSlot: TimetableSlots!
    var selectedStudents: [Int] = [] {
        didSet{
            if assignForAllButton != nil {
                if self.selectedStudents.isEmpty {
                    self.assignForAllButton.setTitle("Assign for all".localized, for: .normal)
                } else {
                    self.assignForAllButton.setTitle("Assign for selected".localized, for: .normal)
                }
            }
        }
    }
    
    var slotAttendanceObject: FullDayAttendances!
    var fullDayAttendanceObject: FullDayAttendances!
    
    var studentsMap: [Int: [Attendances]]!  //childID, Attendances array
    var currentStudents: [AttendanceStudent]!
    
    enum AttendanceRequestType: String {
        case post = "post"
        case put = "put"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        
        timeTableSlots = []
        selectedStudents = []
        currentStudents = []
        
        day = Date().day
        month = Date().month
        year = Date().year
        isFullDay = true
        leftLabel.text = "\(getTodayName().capitalizingFirstLetter().localized) \(Date().day)"
        studentsMap = [:]
        getFullDayData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpData()
    }
    
    func getFullDayData() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getFullDayAttendanceStudentsApi(courseGroupId: courseGroupId, startDate: "\(day)%2F\(month)%2F\(year)", endDate: "\(day)%2F\(month)%2F\(year)") { (isSuccess, statusCode, value, error) in
            if isSuccess {
                self.fullDayAttendanceObject = value.map{FullDayAttendances($0 as! [String : Any])}
                self.getSlotData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func getSlotData() {
        getSlotAttendanceStudentsApi(courseGroupId: courseGroupId, date: "\(day)%2F\(month)%2F\(year)") { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            assignPlaceholder(self.tableView, imageName: "attendanceplaceholder", placeHolderLabelText: "You don't have any attendances for now".localized)
            if isSuccess {
                self.slotAttendanceObject = value.map{FullDayAttendances($0 as! [String : Any])}
                self.timeTableSlots = self.slotAttendanceObject.timetableSlots
                self.setUpData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func setUpData() {
        currentStudents = []
        guard fullDayAttendanceObject != nil else {
            return
        }
        guard slotAttendanceObject != nil else {
            return
        }
        
        if isFullDay {
            for student in self.fullDayAttendanceObject.students {
                self.currentStudents.append(student)
                self.studentsMap[student.childId] = self.fullDayAttendanceObject.attendances.filter({ (attendance) -> Bool in
                    return attendance.studentId == student.childId
                })
                self.highlightFullDayUi()
                self.leftLabel.text = "\(self.getTodayName().capitalizingFirstLetter().localized) \(Date().day)"
                self.calendarImageView.isHidden = false
            }
        } else {
            for student in self.slotAttendanceObject.students {
                self.currentStudents.append(student)
                self.studentsMap[student.childId] = self.slotAttendanceObject.attendances.filter({ (attendance) -> Bool in
                    return attendance.studentId == student.childId
                })
            }
        }
        self.tableView.reloadData()
    }
    
    func highlightFullDayUi() {
        fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
        fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
        slotAttendanceBottomBar.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        slotAttendanceButton.setTitleColor(#colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1), for: .normal)
    }
    func highlightSlotUi() {
        slotAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
        slotAttendanceBottomBar.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
        fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1), for: .normal)
    }
    private func getTodayName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: Date())
        return dayInWeek
    }
    
    func presentSlotsViewController() {
        if self.timeTableSlots.contains(where: {$0.day.elementsEqual(self.getTodayName().lowercased())}) {
            let selectSlotsVc = SelectSlotsViewController.instantiate(fromAppStoryboard: .Attendance)
            selectSlotsVc.timeTableSlots = self.timeTableSlots.filter({(timeSlot) -> Bool in
                return timeSlot.day.elementsEqual(getTodayName().lowercased())})
            selectSlotsVc.didSelectSlot = { (selectedSlot) in
                self.highlightSlotUi()
                self.selectedSlot = selectedSlot
                self.leftLabel.text = "\("Slot".localized) \(selectedSlot.slotNo!)"
                self.calendarImageView.isHidden = true
                self.isFullDay = false
            }
            self.navigationController?.pushViewController(selectSlotsVc, animated:true)
        } else {
            debugPrint("no slots available")
            let alert = UIAlertController(title: "Skolera".localized, message: "No slots available".localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            alert.modalPresentationStyle = .fullScreen
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func submitAttendance(student: AttendanceStudent, type: AttendanceRequestType, status: String, comment: String = "") {
        var parameters: Parameters = [:]
        var attendancesKey: [[String: Any]] = []
        var attendanceParam: [String: Any] = [:]
        attendanceParam["date"] = "\(self.day)-\(self.month)-\(self.year)"
        attendanceParam["student_id"] = student.childId!
        if !isFullDay {
            if let slot = self.selectedSlot {
                attendanceParam["timetable_slot_id"] = slot.id!
            }
        }
        attendanceParam["comment"] = comment
        attendanceParam["status"] = status
        attendancesKey.append(attendanceParam)
        parameters["attendance"] = ["attendances": attendancesKey]
        if let attendance = studentsMap[student.childId!]?.first {
            if let statusString = attendance.status, statusString.elementsEqual(status) {
                debugPrint("Skip this attendance")
            } else {
                createNewAttendance(parameters)
            }
        } else {
            createNewAttendance(parameters)
        }
    }
    
    func submitBatchAttendance(status: String) {
        var parameters: Parameters = [:]
        var attendancesKey: [[String: Any]] = []
        var createNewAttendanceStudents: [Int] = []
        var attendanceParam: [String: Any] = [:]
        var slotId: Int!
        
        if !self.isFullDay {
            if let slot = self.selectedSlot {
                slotId = slot.id!
            }
        }
        for student in selectedStudents {
            createNewAttendanceStudents.append(student)
        }
        selectedStudents = []
        for id in createNewAttendanceStudents {
            attendanceParam["date"] = "\(self.day)-\(self.month)-\(self.year)"
            attendanceParam["student_id"] = id
            attendanceParam["comment"] = ""
            attendanceParam["status"] = status
            if !isFullDay {
                attendanceParam["timetable_slot_id"] = slotId!
            }
            
            attendancesKey.append(attendanceParam)
        }
        parameters["attendance"] = ["attendances": attendancesKey]
        createNewAttendance(parameters)
    }
    
    func createNewAttendance(_ parameters: Parameters) {
        //        TO DO: must check that the latest attendance state is not the same
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        createFullDayAttendanceApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                self.getFullDayData()   //retrieves all the values again
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func deleteAttendances() {
        var parameters: Parameters = [:]
        var deletedAttendances: [Int] = []
        if selectedStudents.isEmpty {
            for attendances in studentsMap.values {
                for attendance in attendances {
                    deletedAttendances.append(attendance.id!)
                }
            }
        } else {
            //delete attendance for selected students only
            let students = studentsMap.filter { (childId, attendances) -> Bool in
                self.selectedStudents.contains(childId)
            }
            for student in students {
                if let attendanceVal = student.value.first {
                    deletedAttendances.append(attendanceVal.id!)
                } else  {
                    debugPrint("no attendance for this student")
                }
            }
        }
        selectedStudents = []
        parameters["ids"] = deletedAttendances
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        deleteAttendancesApi(parameters: parameters) {  (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                self.getFullDayData()   //retrieves all the values again
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    //    MARK: - IBActions
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fullDayAttendanceButtonAction() {
        if !isFullDay {
            isFullDay = true
            setUpData()
        }
    }
    
    @IBAction func slotAttendanceButtonAction() {
        presentSlotsViewController()
    }
    
    @IBAction func assignForAllButtonAction() {
        
        if selectedStudents.isEmpty {
            selectedStudents = [Int](studentsMap.keys)
        } else {
            debugPrint(studentsMap.keys.count, "selected")
        }
        let title = "Assign action for all students".localized
        let presentString = "Present".localized
        let lateString = "Late".localized
        let absentString = "Absent".localized
        let removeStatusString = "Remove all status".localized
        let alert = UIAlertController(title: "", message: "Assign action for all students".localized, preferredStyle: .actionSheet)
        let font = UIFont.systemFont(ofSize: 18)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1),
        ]
        alert.setValue(NSAttributedString(string: title, attributes: titleAttributes), forKey: "attributedMessage")
        
        let presentImage = #imageLiteral(resourceName: "presentSelected").resizeImage(CGFloat(signOf: 20, magnitudeOf: 20),opaque: false)
        let presentAction = UIAlertAction(title: presentString, style: .default, handler: { (_) in
            print("User click present button")
            self.submitBatchAttendance(status: "present")
        })
        presentAction.setValue(presentImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
        presentAction.setValue(#colorLiteral(red: 0.4, green: 0.7333333333, blue: 0.4156862745, alpha: 1), forKey: "titleTextColor")
        alert.addAction(presentAction)
        
        let lateImage = #imageLiteral(resourceName: "lateSelected").resizeImage(CGFloat(signOf: 20, magnitudeOf: 20),opaque: false)
        let lateAction = UIAlertAction(title: lateString, style: .default, handler: { (_) in
            print("User click late button")
            self.submitBatchAttendance(status: "late")
        })
        lateAction.setValue(lateImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
        lateAction.setValue(#colorLiteral(red: 0.9843137255, green: 0.7529411765, blue: 0.1764705882, alpha: 1), forKey: "titleTextColor")
        alert.addAction(lateAction)
        
        let absentImage = #imageLiteral(resourceName: "absentSelected").resizeImage(CGFloat(signOf: 20, magnitudeOf: 20),opaque: false)
        let absentAction = UIAlertAction(title: absentString, style: .default, handler: { (_) in
            print("User click absent button")
            self.submitBatchAttendance(status: "absent")
        })
        absentAction.setValue(absentImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
        absentAction.setValue(#colorLiteral(red: 0.9921568627, green: 0.5098039216, blue: 0.4078431373, alpha: 1), forKey: "titleTextColor")
        alert.addAction(absentAction)
        
        alert.addAction(UIAlertAction(title: removeStatusString, style: .default, handler: { (_) in
            print("User click delete for all")
            self.deleteAttendances()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (_) in
            print("User click Dismiss button")
            //batch delete
        }))
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}
//MARK: Table View Extension
extension TeacherAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentsMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherAttendanceCell") as! TeacherAttendanceTableViewCell
        cell.resetAll()
        if self.selectedStudents.contains(where: { (studentId) -> Bool in
            self.currentStudents[indexPath.row].childId == studentId
        }) {
            cell.selectStudent()
        } else {
            cell.deselectStudent()
        }
        
        cell.didSelectStudent = { (selectedStudent) -> () in
            var isSelected = false
            isSelected = self.selectedStudents.contains(where: { (studentId) -> Bool in
                studentId == selectedStudent.childId!
            })
            if isSelected {
                self.selectedStudents.removeAll{ (studentId) -> Bool in
                    studentId == selectedStudent.childId!
                }
                cell.deselectStudent()
            } else {
                cell.studentSelectButton.setImage(#imageLiteral(resourceName: "attendanceCheck"), for: .normal)
                self.selectedStudents.append(selectedStudent.childId!)
                cell.selectStudent()
            }
        }
        
        cell.didSelectAttendanceState = { state, selectedStudent in
            var status = ""
            var type: AttendanceRequestType!
            if self.studentsMap[selectedStudent.childId]!.count > 0 {
                type = .put
            } else {
                type = .post
            }
            switch state {
            case .present:
                status = "present"
                self.submitAttendance(student: selectedStudent, type: type, status: status)
            case .late:
                status = "late"
                self.submitAttendance(student: selectedStudent, type: type, status: status)
            case .absent:
                status = "absent"
                self.submitAttendance(student: selectedStudent, type: type, status: status)
            case .excused:
                status = "excused"
                let submitExcuse = SubmitExcuseViewController.instantiate(fromAppStoryboard: .Attendance)
                submitExcuse.didSubmit = { comment in
                    self.submitAttendance(student: selectedStudent, type: type, status: status, comment: comment)
                }
                //                self.navigationController?.pushViewController(submitExcuse, animated: false)
                submitExcuse.modalPresentationStyle = .fullScreen
                self.present(submitExcuse, animated: true, completion: nil)
            }
        }
        
        if self.studentsMap[self.currentStudents[indexPath.row].childId!]!.count > 0 {
            let attendance = self.studentsMap[self.currentStudents[indexPath.row].childId!]!.sorted { (first, second) -> Bool in
                first.id > second.id
            }.first
            if let _ = attendance?.timetableSlotId {
                if isFullDay {
                    cell.resetAll()
                } else {
                    cell.applyState(attendanceCase: AttendanceCases(rawValue: attendance!.status!) ?? .present)
                }
            } else {    //case fullday
                if !isFullDay {
                    cell.resetAll()
                } else {
                    cell.applyState(attendanceCase: AttendanceCases(rawValue: attendance!.status!) ?? .present)
                }
            }
        }
        
        cell.student = self.currentStudents[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 124
    }
}


