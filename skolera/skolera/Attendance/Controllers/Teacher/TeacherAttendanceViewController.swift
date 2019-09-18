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

    var timeTableSlots: [TimetableSlots]!


    var day = Date().day
    var month = Date().month
    var year = Date().year
    var isFullDay: Bool!
    var selectedSlot: TimetableSlots!
    var selectedStudents: [AttendanceStudent]!
    
    
    
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
        isFullDay = false
        leftLabel.text = "\(getTodayName().capitalizingFirstLetter()) \(Date().day)"
        studentsMap = [:]
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpData()
    }
    
    func setUpData() {
        if isFullDay {
            SVProgressHUD.show(withStatus: "Loading".localized)
            getFullDayAttendanceStudentsApi(courseGroupId: courseGroupId, startDate: "\(day)%2F\(month)%2F\(year)", endDate: "\(day)%2F\(month)%2F\(year)") { (isSuccess, statusCode, value, error) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.fullDayAttendanceObject = value.map{FullDayAttendances($0 as! [String : Any])}
                    for student in self.fullDayAttendanceObject.students {
                        debugPrint(self.studentsMap!)
                        self.studentsMap[student.childId] = self.fullDayAttendanceObject.attendances.filter({ (attendance) -> Bool in
                            debugPrint(student.childId)
                            self.currentStudents.append(student)
                            return attendance.studentId == student.childId
                        })
                        
                    }
                    self.fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
                    self.fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                    self.leftLabel.text = "\(self.getTodayName().capitalizingFirstLetter()) \(Date().day)"
                    self.tableView.reloadData()
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        } else {
            SVProgressHUD.show(withStatus: "Loading".localized)
            getSlotAttendanceStudentsApi(courseGroupId: courseGroupId, date: "\(day)%2F\(month)%2F\(year)") { (isSuccess, statusCode, value, error) in
                SVProgressHUD.dismiss()
                if isSuccess {
                    self.slotAttendanceObject = value.map{FullDayAttendances($0 as! [String : Any])}
                    for student in self.slotAttendanceObject.students {
                        self.studentsMap[student.childId] = self.slotAttendanceObject.attendances.filter({ (attendance) -> Bool in
                            debugPrint(student.childId)
                            self.currentStudents.append(student)
                            return attendance.studentId == student.childId
                        })
                    }
                    self.timeTableSlots = self.slotAttendanceObject.timetableSlots
//                    if self.timeTableSlots.contains(where: {$0.day.elementsEqual(self.getTodayName().lowercased())}) {
//                        self.presentSlotsViewController()
//                    } else {
//                        debugPrint("no slots available")
//                        //alert dialogue no slots available
//                    }
                    self.tableView.reloadData()
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
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
        
        switch (type) {
        case .post:
            var attendancesKey: [[String: Any]] = []
            var attendanceParam: [String: Any] = [:]
            attendanceParam["date"] = "\(self.day)-\(self.month)-\(self.year)"
            attendanceParam["student_id"] = childId
            if isFullDay {
                attendanceParam["timetable_slot_id"] = ""
            } else {
                if let slot = self.selectedSlot {
                    attendanceParam["timetable_slot_id"] = slot.id!
                }
            }
            attendanceParam["comment"] = comment
            attendanceParam["status"] = status
            attendancesKey.append(attendanceParam)
            parameters["attendance"] = ["attendances": attendancesKey]
            debugPrint(parameters)
            createNewAttendance(parameters)
        case .put:
            debugPrint("put")
            attendanceId = studentsMap[childId]?.first?.id
            guard let id = attendanceId else {
                return
            }
            parameters["attendance"] = ["status": status, "comment" : comment, "timetable_slot_id": "" ]
            parameters["id"] = id
            debugPrint(parameters)
            updateAttendance(id, parameters)
        }
    }
    
    func submitBatchAttendance(status: String) {
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
        if !self.isFullDay {
            if let slot = self.selectedSlot {
                slotId = slot.id!
            }
        }
        
        for student in selectedStudents {
            if studentsMap[student.childId]!.count > 0  { //update case
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
//                    self.getFullDayAttendanceStudents()
                    debugPrint("full day")
                } else {
//                    self.getSlotAttendanceStudents()
                    debugPrint("slots")
                    
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
//                self.getFullDayAttendanceStudents()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fullDayAttendanceButtonAction() {
//        getFullDayAttendanceStudents()
    }
    
    @IBAction func slotAttendanceButtonAction() {
//        getSlotAttendanceStudents()
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
        
        alert.addAction(UIAlertAction(title: removeStatusString, style: .cancel, handler: { (_) in
            print("User click Dismiss button")
            //batch delete
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension TeacherAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.studentsMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherAttendanceCell") as! TeacherAttendanceTableViewCell
        cell.resetAll()
        

//        selection of students
//        if self.selectedStudents.contains(where: { (student) -> Bool in
//            self.students[indexPath.row].childId == student.childId
//        }) {
//            cell.selectStudent()
//        } else {
//            cell.deselectStudent()
//        }
        
        
        
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
            var students: [AttendanceStudent] = []
            var status = ""
            var type: AttendanceRequestType!
            if flag {
                type = .put
            } else {
                type = .post
            }
            if self.isFullDay {
                students = self.students
            } else {
                students = self.slotStudents
            }
            switch state {
            case .present:
                status = "present"
                self.submitAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status)
            case .late:
                status = "late"
                self.submitAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status)
            case .absent:
                status = "absent"
                self.submitAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status)
            case .excused:
                status = "excused"
                let submitExcuse = SubmitExcuseViewController.instantiate(fromAppStoryboard: .Attendance)
                submitExcuse.didSubmit = { comment in
                    self.submitAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status, comment: comment)
                }
//                self.navigationController?.pushViewController(submitExcuse, animated: false)
                self.present(submitExcuse, animated: true, completion: nil)
            }
        }
        
        cell.student = self.currentStudents[indexPath.row]
        
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


