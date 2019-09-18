//
//  TeacherAttendanceViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/1/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class TeacherAttendanceViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullDayAttendanceButton: UIButton!
    @IBOutlet weak var fullDayAttendanceBottomBorder: UIView!
    @IBOutlet weak var slotAttendanceBottomBar: UIView!
    @IBOutlet weak var slotAttendanceButton: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var assignForAllButton: UIButton!
    
    var courseGroupId: Int!
    var students: [AttendanceStudent]!
    var slotStudents: [AttendanceStudent]!
    var attedances: [Attendances]!
    var slotAttendances: [Attendances]!
    var timeTableSlots: [TimetableSlots]!
    var attendanceStudents: [AttendanceStudent]!
    var slotAttendanceStudents: [AttendanceStudent]!
    var slotAttendance: FullDayAttendances!
    var day = Date().day
    var month = Date().month
    var year = Date().year
    var isFullDay: Bool!
    var selectedSlot: TimetableSlots!
    var selectedStudents: [AttendanceStudent]!
    enum AttendanceRequestType: String {
        case post = "post"
        case put = "put"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        students = []
        getFullDayAttendanceStudents()
        attendanceStudents = []
        timeTableSlots = []
        slotStudents = []
        slotAttendances = []
        slotAttendanceStudents = []
        selectedStudents = []
        day = Date().day
        month = Date().month
        year = Date().year
        isFullDay = true
        leftLabel.text = "\(getTodayName().capitalizingFirstLetter()) \(Date().day)"
        
    }
    func getFullDayAttendanceStudents() {
        isFullDay = true
        SVProgressHUD.show(withStatus: "Loading".localized)
        getFullDayAttendanceStudentsApi(courseGroupId: courseGroupId, startDate: "\(day)%2F\(month)%2F\(year)", endDate: "\(day)%2F\(month)%2F\(year)") { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.slotAttendance = value.map{FullDayAttendances($0 as! [String : Any])}
                self.students = self.slotAttendance.students
                self.attedances = self.slotAttendance?.attendances
                for attendance in self.attedances {
                   self.attendanceStudents.append(attendance.student)
                }
                self.fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
                self.fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                self.leftLabel.text = "\(self.getTodayName().capitalizingFirstLetter()) \(Date().day)"
                self.tableView.reloadData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    private func getTodayName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: Date())
        return dayInWeek
    }
    
    func getSlotAttendanceStudents() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getSlotAttendanceStudentsApi(courseGroupId: courseGroupId, date: "\(day)%2F\(month)%2F\(year)") { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.slotAttendance = value.map{FullDayAttendances($0 as! [String : Any])}
                self.slotStudents = self.slotAttendance.students
                self.slotAttendances = self.slotAttendance?.attendances
                self.timeTableSlots = self.slotAttendance?.timetableSlots
                debugPrint(self.timeTableSlots)
                for attendance in self.slotAttendances {
                    self.slotAttendanceStudents.append(attendance.student)
                }
                if self.timeTableSlots.contains(where: {$0.day.elementsEqual(self.getTodayName().lowercased())}) {
                    self.presentSlotsViewController()
                } else {
                    debugPrint("no slots available")
                    //alert dialogue no slots available
                }
                self.tableView.reloadData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func presentSlotsViewController() {
        let selectSlotsVc = SelectSlotsViewController.instantiate(fromAppStoryboard: .Attendance)
        selectSlotsVc.timeTableSlots = self.timeTableSlots.filter({(timeSlot) -> Bool in
            return timeSlot.day.elementsEqual(getTodayName().lowercased())})
        selectSlotsVc.didSelectSlot = { (selectedSlot) in
            self.slotAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
            self.slotAttendanceBottomBar.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
            self.fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            self.fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1), for: .normal)
            self.selectedSlot = selectedSlot
            debugPrint("Slot Index is:" , selectedSlot.slotNo!)
            self.leftLabel.text = "Slot \(selectedSlot.slotNo!)"
            self.isFullDay = false
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(selectSlotsVc, animated:true)
    }
    
    func submitAttendance(childId: Int, type: AttendanceRequestType, status: String, comment: String = "") {
        var attendanceId: Int!
        var parameters: Parameters = [:]
        if let attendanceIndex = self.attedances.firstIndex(where: { $0.student.childId == childId }) {
            attendanceId = self.attedances[attendanceIndex].id!
        }
        switch (type) {
        case .post:
            var attendancesKey: [[String: Any]] = []
            var attendance: [String: Any] = [:]
            attendance["date"] = "\(self.day)-\(self.month)-\(self.year)" 
            attendance["student_id"] = childId
            if isFullDay {
                attendance["timetable_slot_id"] = ""
            } else {
                if let slot = self.selectedSlot {
                    attendance["timetable_slot_id"] = slot.id!
                }
            }
            attendance["comment"] = comment
            attendance["status"] = status
            attendancesKey.append(attendance)
            parameters["attendance"] = ["attendances": attendancesKey]
            debugPrint(parameters)
            createNewAttendance(parameters)
        case .put:
            debugPrint("put")
            guard let id = attendanceId else {
                return
            }
            parameters["attendance"] = ["status": status, "comment" : comment, "timetable_slot_id": "" ]
            parameters["id"] = id
            debugPrint(parameters)
            updateAttendance(id, parameters)
        }
    }
    
    func submitBatchAttendance(status: String, timeTableSlot: TimetableSlots!) {
        //create, update
        //create for batch
        var attendanceId: Int!
        var parameters: Parameters = [:]
        var attendancesKey: [[String: Any]] = []
        var createNewAttendanceStudents: [AttendanceStudent] = []
        var updateAttendanceStudents: [AttendanceStudent] = []
        var attendances: [Attendances] = []
        var attendanceParam: [String: Any] = [:]
        var slotId: Int!
//        if let attendanceIndex = self.attedances.firstIndex(where: { $0.student.childId == childId }) {
//            attendanceId = self.attedances[attendanceIndex].id!
//        }
        if self.isFullDay {
            attendances = self.attedances
        } else {
            attendances = self.slotAttendances
            if let slot = self.selectedSlot {
                slotId = slot.id!
            }
        }
        
        for student in selectedStudents {
            if let attendanceIndex = self.attedances.firstIndex(where: { $0.student.childId == student.childId }) { //update case
//                attendanceId = self.attedances[attendanceIndex].id!
                updateAttendanceStudents.append(student)
            } else {
                createNewAttendanceStudents.append(student)
            }
        }
        
        for student in createNewAttendanceStudents {
            attendanceParam["date"] = "\(self.day)-\(self.month)-\(self.year)"
            attendanceParam["student_id"] = student.childId!
            attendanceParam["comment"] = ""
            attendanceParam["status"] = status
            attendanceParam["timetable_slot_id"] = slotId ?? ""
            attendancesKey.append(attendanceParam)
        }
        
        parameters["attendance"] = ["attendances": attendancesKey]
        debugPrint(parameters)
        createNewAttendance(parameters)
        
    }
    
    func createNewAttendance(_ parameters: Parameters) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        createFullDayAttendanceApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if self.isFullDay {
                    self.getFullDayAttendanceStudents()
                } else {
                    self.getSlotAttendanceStudents()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func updateAttendance(_ attendanceId: Int, _ parameters: Parameters) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        updateAttendanceApi(attendanceId: attendanceId, parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.getFullDayAttendanceStudents()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fullDayAttendanceButtonAction() {
        getFullDayAttendanceStudents()
    }
    
    @IBAction func slotAttendanceButtonAction() {
        getSlotAttendanceStudents()
    }
    
    @IBAction func assignForAllButtonAction() {
        
        let title = "Assign action for all students"
        let presentString = "Present"
        let lateString = "Late"
        let absentString = "Absent"
        let removeStatusString = "Remove all status"
        let alert = UIAlertController(title: "", message: "Assign action for all students", preferredStyle: .actionSheet)
        let font = UIFont.systemFont(ofSize: 18)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1),
        ]
        alert.setValue(NSAttributedString(string: title, attributes: titleAttributes), forKey: "attributedMessage")
        
        let presentImage = #imageLiteral(resourceName: "presentSelected").resizeImage(CGFloat(signOf: 20, magnitudeOf: 20),opaque: false)
        let presentAction = UIAlertAction(title: presentString, style: .default, handler: { (_) in
            print("User click present button")
        })
        presentAction.setValue(presentImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
        presentAction.setValue(#colorLiteral(red: 0.4, green: 0.7333333333, blue: 0.4156862745, alpha: 1), forKey: "titleTextColor")
        alert.addAction(presentAction)
        
        let lateImage = #imageLiteral(resourceName: "lateSelected").resizeImage(CGFloat(signOf: 20, magnitudeOf: 20),opaque: false)
        let lateAction = UIAlertAction(title: lateString, style: .default, handler: { (_) in
            print("User click late button")
        })
        lateAction.setValue(lateImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
        lateAction.setValue(#colorLiteral(red: 0.9843137255, green: 0.7529411765, blue: 0.1764705882, alpha: 1), forKey: "titleTextColor")
        alert.addAction(lateAction)
        
        let absentImage = #imageLiteral(resourceName: "absentSelected").resizeImage(CGFloat(signOf: 20, magnitudeOf: 20),opaque: false)
        let absentAction = UIAlertAction(title: absentString, style: .default, handler: { (_) in
            print("User click absent button")
        })
        absentAction.setValue(absentImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal), forKey: "image")
        absentAction.setValue(#colorLiteral(red: 0.9921568627, green: 0.5098039216, blue: 0.4078431373, alpha: 1), forKey: "titleTextColor")
        alert.addAction(absentAction)
        
        alert.addAction(UIAlertAction(title: removeStatusString, style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension TeacherAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFullDay {
            return self.students.count
        } else {
            return self.slotStudents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var flag = false
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherAttendanceCell") as! TeacherAttendanceTableViewCell
        cell.resetAll()
        if isFullDay {
            flag = attendanceStudents.contains(where: { (attendanceStudent) -> Bool in
                self.students[indexPath.row].childId == attendanceStudent.childId
            })
            if self.selectedStudents.contains(where: { (student) -> Bool in
                self.students[indexPath.row].childId == student.childId
            }) {
                cell.selectStudent()
            } else {
                cell.deselectStudent()
            }
        } else {
            debugPrint(flag)
            flag = slotAttendanceStudents.contains(where: {(slotAttendanceStudent) -> Bool in
                self.slotStudents[indexPath.row].childId == slotAttendanceStudent.childId
            })
        }
        
        cell.didSelectStudent = {
            if self.isFullDay {
                if self.selectedStudents.contains(where: { (student) -> Bool in
                    self.students[indexPath.row].childId == student.childId }) {
                    self.selectedStudents.removeAll(where: { (student) -> Bool in
                        student.childId == self.students[indexPath.row].childId
                    })
                    cell.deselectStudent()
                } else {
                    cell.studentSelectButton.setImage(#imageLiteral(resourceName: "attendanceCheck"), for: .normal)
                    self.selectedStudents.append(self.students[indexPath.row])
                    cell.selectStudent()
                }
            } else {
                //same check for slots selection
            }
            if self.selectedStudents.count > 0 {
                self.assignForAllButton.titleLabel?.text = "Assign for selected"
            } else {
                self.assignForAllButton.titleLabel?.text = "Assign for all"
            }
        }
        
        cell.didSelectAttendanceState = { state in
            var status = ""
            var type: AttendanceRequestType!
            if flag {
                type = .put
            } else {
                type = .post
            }
            switch state {
            case .present:
                status = "present"
                self.submitAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status)
            case .late:
                status = "late"
                self.submitAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status)
            case .absent:
                status = "absent"
                self.submitAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status)
            case .excused:
                status = "excused"
                let submitExcuse = SubmitExcuseViewController.instantiate(fromAppStoryboard: .Attendance)
                submitExcuse.didSubmit = { comment in
                    self.submitAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status, comment: comment)
                }
//                self.navigationController?.pushViewController(submitExcuse, animated: false)
                self.present(submitExcuse, animated: true, completion: nil)
            }
        }
        
        if self.isFullDay == true {
            cell.studentNameLabel.text = self.students[indexPath.row].name ?? ""
            cell.studentImageView.childImageView(url: self.students[indexPath.row].avatarUrl, placeholder: "\(self.students[indexPath.row].name.prefix(2).uppercased())", textSize: 14)
        } else {
            cell.studentNameLabel.text = self.slotStudents[indexPath.row].name ?? ""
            cell.studentImageView.childImageView(url: self.slotStudents[indexPath.row].avatarUrl, placeholder: "\(self.slotStudents[indexPath.row].name.prefix(2).uppercased())", textSize: 14)
        }
        
        if isFullDay {
            if let cellAttendance = self.attedances.first(where: { $0.student.childId == self.students[indexPath.row].childId}) {
                if let _ = cellAttendance.timetableSlotId {
                    cell.resetAll()
                } else {
                    cell.applyState(attendanceCase: AttendanceCases(rawValue: cellAttendance.status!) ?? .present)
                }
            }
        } else {
            if let cellAttendance = self.slotAttendances.first(where: {$0.student.childId == self.slotStudents[indexPath.row].childId}) {
                debugPrint("hello")
                cell.applyState(attendanceCase: AttendanceCases(rawValue: cellAttendance.status!) ?? .present)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
}


