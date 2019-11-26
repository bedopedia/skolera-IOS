//
//  AttendanceViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/11/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import CVCalendar

class AttendanceViewController: UIViewController {
    
    enum weekDays : Int{
        case sunday = 0
        case monday = 1
        case tuesday = 2
        case wednesday = 3
        case thursday = 4
        case friday = 5
        case saturday = 6
    }
    
    //MARK: - Variables
    var child : Child!
    let calendar = Calendar.current
    var currentDataSource = [Attendance]()
    var currentBorderColor: UIColor!
    let today = Date()
    var offDays =  Set <weekDays> ()
    
    //MARK: - Outlets
    
    //calendar outlets
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var lateDaysNumberLabel: UILabel!
    @IBOutlet weak var absentDaysNumberLabel: UILabel!
    @IBOutlet weak var excusedDaysNumberLabel: UILabel!
    @IBOutlet weak var lateBottomBorderView: UIView!
    @IBOutlet weak var excusedBottomBorderView: UIView!
    @IBOutlet weak var absentBottomBorderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    
    
    //MARK: - Life Cycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        self.view.layoutIfNeeded()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.rowHeight = UITableViewAutomaticDimension
        loadLateDays()
        loadExcusedDays()
        loadAbsentDays()
        offDays.insert(.friday)
        offDays.insert(.saturday)
        setupWeekDaysLabels()
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Actions
    
    @IBAction func toggleToToday() {
//        calendarView.
    }
    
    @IBAction func switchToLate(_ sender: UIButton) {
        lateBottomBorderView.isHidden = false
        excusedBottomBorderView.isHidden = true
        absentBottomBorderView.isHidden = true
        loadLateDays()
    }
    
    @IBAction func switchToExcused(_ sender: UIButton) {
        lateBottomBorderView.isHidden = true
        excusedBottomBorderView.isHidden = false
        absentBottomBorderView.isHidden = true
        loadExcusedDays()
    }
    
    @IBAction func switchToAbsent(_ sender: UIButton) {
        lateBottomBorderView.isHidden = true
        excusedBottomBorderView.isHidden = true
        absentBottomBorderView.isHidden = false
        loadAbsentDays()
    }
}

