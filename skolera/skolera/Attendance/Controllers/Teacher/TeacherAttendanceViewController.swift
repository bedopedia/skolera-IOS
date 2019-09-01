//
//  TeacherAttendanceViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/1/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherAttendanceViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fullDayAttendanceButton: UIButton!
    @IBOutlet weak var fullDayAttendanceBottomBorder: UIView!
    @IBOutlet weak var slotAttendanceBottomBar: UIView!
    @IBOutlet weak var slotAttendanceButton: UIButton!
    
    var students: [Student]!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        students = []

    }
    
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func fullDayAttendanceButtonAction() {
        
    }
    
    @IBAction func slotAttendanceButtonAction() {
        
    }

    
}

extension TeacherAttendanceViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherAttendanceCell") as! TeacherAttendanceTableViewCell
        cell.studentSelectButton.layer.borderWidth = 1
        cell.studentSelectButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        cell.didSelectStudent = {
            if self.students.indices.contains(indexPath.row) { //student is being unselected
                cell.studentSelectButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.studentSelectButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
            } else {
                cell.studentSelectButton.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                cell.studentSelectButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                cell.studentSelectButton.setImage(#imageLiteral(resourceName: "attendanceCheck"), for: .normal)
            }
        }
        cell.didSelectAttendanceState = { state in
            debugPrint("state is selected is \(state)")
            // nw calls, should check if this student had been assigned a state
            switch state {
            case .present:
                cell.lateButton.setImage(#imageLiteral(resourceName: "late"), for: .normal)
                cell.lateButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.lateButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.presentButton.setImage(#imageLiteral(resourceName: "presentSelected"), for: .normal)
                cell.presentButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.937254902, blue: 0.8039215686, alpha: 1)
                cell.presentButton.setTitleColor(#colorLiteral(red: 0.4, green: 0.7333333333, blue: 0.4156862745, alpha: 1), for: .normal)
                
                cell.excusedButton.setImage(#imageLiteral(resourceName: "excused"), for: .normal)
                cell.excusedButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.excusedButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.absentButton.setImage(#imageLiteral(resourceName: "absent"), for: .normal)
                cell.absentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.absentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                
            case .late:
                cell.lateButton.setImage(#imageLiteral(resourceName: "lateSelected"), for: .normal)
                cell.lateButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9098039216, blue: 0.737254902, alpha: 1)
                cell.lateButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.7529411765, blue: 0.1764705882, alpha: 1), for: .normal)
                
                cell.presentButton.setImage(#imageLiteral(resourceName: "present"), for: .normal)
                cell.presentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.presentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.excusedButton.setImage(#imageLiteral(resourceName: "excused"), for: .normal)
                cell.excusedButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.excusedButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.absentButton.setImage(#imageLiteral(resourceName: "absent"), for: .normal)
                cell.absentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.absentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
            case .absent:
                cell.lateButton.setImage(#imageLiteral(resourceName: "late"), for: .normal)
                cell.lateButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.lateButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.presentButton.setImage(#imageLiteral(resourceName: "present"), for: .normal)
                cell.presentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.presentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.excusedButton.setImage(#imageLiteral(resourceName: "excused"), for: .normal)
                cell.excusedButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.excusedButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.absentButton.setImage(#imageLiteral(resourceName: "absentSelected"), for: .normal)
                cell.absentButton.backgroundColor = #colorLiteral(red: 1, green: 0.8784313725, blue: 0.8745098039, alpha: 1)
                cell.absentButton.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.5098039216, blue: 0.4078431373, alpha: 1), for: .normal)
            case .excused:
                cell.lateButton.setImage(#imageLiteral(resourceName: "late"), for: .normal)
                cell.lateButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.lateButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.presentButton.setImage(#imageLiteral(resourceName: "present"), for: .normal)
                cell.presentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.presentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
                
                cell.excusedButton.setImage(#imageLiteral(resourceName: "excusedSelected"), for: .normal)
                cell.excusedButton.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.8705882353, blue: 0.9803921569, alpha: 1)
                cell.excusedButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
                
                cell.absentButton.setImage(#imageLiteral(resourceName: "absent"), for: .normal)
                cell.absentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
                cell.absentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
         
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    // implementation of protocol requirements goes here
}


