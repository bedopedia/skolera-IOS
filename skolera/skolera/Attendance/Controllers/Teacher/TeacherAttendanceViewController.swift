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
        fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
        fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
        getFullDayAttendanceStudents()
        attendanceStudents = []
        timeTableSlots = []
        slotStudents = []
        slotAttendances = []
        slotAttendanceStudents = []
        day = Date().day
        month = Date().month
        year = Date().year
        isFullDay = true
        
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
                self.tableView.reloadData()
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
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
                for attendance in self.slotAttendances {
                    self.slotAttendanceStudents.append(attendance.student)
                }
                self.presentSlotsViewController()
                
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func presentSlotsViewController() {
        let selectSlotsVc = SelectSlotsViewController.instantiate(fromAppStoryboard: .Attendance)
        selectSlotsVc.timeTableSlots = self.timeTableSlots
        selectSlotsVc.didSelectSlot = { (index) in
            debugPrint("Slot Index is:",self.timeTableSlots[index].slotNo!)
            self.leftLabel.text = "Slot \(self.timeTableSlots[index].slotNo!)"
            self.slotAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
            self.slotAttendanceBottomBar.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
            self.fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
            self.fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1), for: .normal)
            self.isFullDay = false
            self.tableView.reloadData()
        }
        selectSlotsVc.cancel = {
//            self.getFullDayAttendanceStudents()
//            self.isFullDay = true
            debugPrint("should display the same data")
        }
        
        self.navigationController?.pushViewController(selectSlotsVc, animated:true)
    }
    
    func createAttendance(childId: Int, type: AttendanceRequestType, status: String, comment: String = "") {
        var attendanceId: Int!
        var parameters: Parameters = [:]
        if let attendanceIndex = self.attedances.firstIndex(where: { $0.student.childId == childId }) {
            debugPrint(" ")
            attendanceId = self.attedances[attendanceIndex].id!
        }
        switch (type) {
        case .post:
            var attendancesKey: [[String: Any]] = []
            var attendance: [String: Any] = [:]
            attendance["date"] = "\(self.day)-\(self.month)-\(self.year)" 
            attendance["student_id"] = childId
            attendance["timetable_slot_id"] = ""
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
    
    func createNewAttendance(_ parameters: Parameters) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        createFullDayAttendanceApi(parameters: parameters) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                self.getFullDayAttendanceStudents()
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
        fullDayAttendanceButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
        fullDayAttendanceBottomBorder.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
        slotAttendanceBottomBar.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
        slotAttendanceButton.setTitleColor(#colorLiteral(red: 0.7254901961, green: 0.7254901961, blue: 0.7254901961, alpha: 1), for: .normal)
        leftLabel.text = "Monday 23"
        getFullDayAttendanceStudents()
    }
    
    @IBAction func slotAttendanceButtonAction() {
        self.getSlotAttendanceStudents()
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
        if isFullDay {
            flag = attendanceStudents.contains(where: { (attendanceStudent) -> Bool in
                self.students[indexPath.row].childId == attendanceStudent.childId
            })
        } else {
            debugPrint(flag)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherAttendanceCell") as! TeacherAttendanceTableViewCell
        cell.resetAll()
        cell.studentSelectButton.layer.borderWidth = 1
        cell.studentSelectButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        cell.didSelectStudent = {
            if self.students.indices.contains(indexPath.row) { //student is being unselected
                cell.studentSelectButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.studentSelectButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
                cell.resetAll()
            } else {
                cell.studentSelectButton.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                cell.studentSelectButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                cell.studentSelectButton.setImage(#imageLiteral(resourceName: "attendanceCheck"), for: .normal)
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
                if self.isFullDay {
                  self.createAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status)
                } else {
                    self.createAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status)
                }
            case .late:
                status = "late"
                if self.isFullDay {
                    self.createAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status)
                } else {
                    self.createAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status)
                }
            case .absent:
                status = "absent"
                if self.isFullDay {
                    self.createAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status)
                } else {
                    self.createAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status)
                }
            case .excused:
                status = "excused"
                let submitExcuse = SubmitExcuseViewController.instantiate(fromAppStoryboard: .Attendance)
                submitExcuse.didSubmit = { comment in
                    if self.isFullDay {
                         self.createAttendance(childId: self.students[indexPath.row].childId!, type: type, status: status, comment: comment)
                    } else {
                         self.createAttendance(childId: self.slotStudents[indexPath.row].childId!, type: type, status: status, comment: comment)
                    }
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
                    switch cellAttendance.status!  {
                    case "present":
                        cell.presentSelected()
                    case "late":
                        cell.lateSelected()
                    case "absent":
                        cell.absentSelected()
                    case "excused":
                        cell.excusedSelected()
                    default:
                        debugPrint("default case")
                    }
                }
            }
        } else {
            if let cellAttendance = self.slotAttendances.first(where: { $0.student.childId == self.slotStudents[indexPath.row].childId}) {
                if let _ = cellAttendance.timetableSlotId {
                    cell.resetAll()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    // implementation of protocol requirements goes here
}


