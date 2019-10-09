//
//  EventsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Alamofire
import NVActivityIndicatorView

class EventsViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var weekDaysStackView: UIStackView!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    enum weekDays : Int{
        case sunday = 0
        case monday = 1
        case tuesday = 2
        case wednesday = 3
        case thursday = 4
        case friday = 5
        case saturday = 6
    }
    
    var child : Child!
    let calendar = Calendar.current
    var currentBorderColor: UIColor = .black
    let today = Date()
    
    
    var oldSelectedEventsPosition: Int = -1
    var selectedEventsPosition: Int = 0
    
    var events: [StudentEvent] = []
    var filteredEvents: [StudentEvent] = []
    
    var academicCount = 0
    var eventsCount = 0
    var vacationsCount = 0
    var personalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(today, animateScroll: false)
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.semanticContentAttribute = .forceLeftToRight
        calendarView.visibleDates { visibleDates in self.updateCurrentMonthLabel(from: visibleDates) }
        setupWeekDaysLabels()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }

        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        createEventButton.layer.borderColor = #colorLiteral(red: 0.1580090225, green: 0.7655162215, blue: 0.3781598806, alpha: 1)
        createEventButton.layer.borderWidth = 1
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEvents()
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleToToday() {
        calendarView.scrollToDate(today)
    }
    
    @IBAction func createNewEvent() {
        let createEventVC = CreateEventViewController.instantiate(fromAppStoryboard: .Events)
        createEventVC.child = child
        self.navigationController?.pushViewController(createEventVC, animated: true)
    }
    
    func updateCurrentMonthLabel(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "MMMM yyyy"
        currentMonthLabel.text = formatter.string(from: date!)
    }
    
    fileprivate func setupWeekDaysLabels() {
        for index in 0..<weekDaysStackView.arrangedSubviews.count {
            let weekDayLabel : UILabel = weekDaysStackView.arrangedSubviews[index] as! UILabel
            weekDayLabel.text = calendar.veryShortWeekdaySymbols[index]
//            if offDays.contains(AttendanceViewController.weekDays(rawValue: index)!) {
//                weekDayLabel.textColor = UIColor.appColors.offDaysColor
//            }
        }
    }
    
    func getEvents() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getEventsAPI(userId: child.userId, startDate: "2010-03-04T00:00:00.000Z", endDate: "2030-03-04T00:00:00.000Z") { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.events = result.map{ StudentEvent($0) }
                    self.filteredEvents = self.events
                    self.academicCount = self.events.filter{ $0.type.elementsEqual("academic") }.count
                    self.eventsCount = self.events.filter{ $0.type.elementsEqual("event") }.count
                    self.vacationsCount = self.events.filter{ $0.type.elementsEqual("vacations") }.count
                    self.personalCount = self.events.filter{ $0.type.elementsEqual("personal") }.count
                    self.calendarView.reloadData()
                    self.tableView.reloadData()
                    self.eventsCollectionView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
}

extension EventsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventTypeCollectionViewCell", for: indexPath) as! EventTypeCollectionViewCell
        cell.bottomBar.isHidden = indexPath.row != selectedEventsPosition
        cell.cellNumber = indexPath.row
        if indexPath.row == 1 {
            cell.numberLabel.text = "\(academicCount)"
        } else if indexPath.row == 2 {
            cell.numberLabel.text = "\(eventsCount)"
        } else if indexPath.row == 3 {
            cell.numberLabel.text = "\(vacationsCount)"
        } else if indexPath.row == 4 {
            cell.numberLabel.text = "\(personalCount)"
        } else {
            cell.numberLabel.text = "\(events.count)"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width / 3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedEventsPosition = indexPath.row
        oldSelectedEventsPosition = selectedEventsPosition
        selectedEventsPosition = indexPath.row
        filteredEvents = events
        if indexPath.row == 0 {
            currentBorderColor = .black
        } else if indexPath.row == 1 {
            filteredEvents = events.filter{ $0.type.elementsEqual("academic") }
            currentBorderColor = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1)
        } else if indexPath.row == 2 {
            filteredEvents = events.filter{ $0.type.elementsEqual("event") }
            currentBorderColor = #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1)
        } else if indexPath.row == 3 {
            filteredEvents = events.filter{ $0.type.elementsEqual("vacations") }
            currentBorderColor = #colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1)
        } else {
            filteredEvents = events.filter{ $0.type.elementsEqual("personal") }
            currentBorderColor = #colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1)
        }
        self.tableView.reloadData()
        collectionView.reloadItems(at: [.init(row: oldSelectedEventsPosition, section: 0), .init(row: selectedEventsPosition, section: 0)])
    }
    
}

extension EventsViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
        cell.setupDayLabel(cellState: cellState)
        cell.setupDotMarkerFor(event: getEventForDate(date: date), forCellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: Date(dateString: "1-1-2000", format: "d-M-y"), endDate: Date(dateString: "1-1-2026", format: "d-M-y"), generateInDates: .forAllMonths, generateOutDates: .off)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateCurrentMonthLabel(from: visibleDates)
    }
    
//    func getAttendanceForDate(date: Date) -> Attendance? {
//        let days = child.attendances.filter { (attendance) -> Bool in
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "en")
//            formatter.dateFormat = "yyyy-MM-dd"
//            return formatter.string(from: attendance.date) == formatter.string(from: date)
//        }
//        return days.first
//    }
    
    func getEventForDate(date: Date) -> StudentEvent?
    {
        let days = events.filter { (event) -> Bool in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.string(from: )
            
            let start: Date = Date(timeIntervalSince1970: TimeInterval(event.startDate!))
            let end: Date = Date(timeIntervalSince1970: TimeInterval(event.endDate!))
            
            guard start < end else {
                return false
            }
            let dateInterval: DateInterval = DateInterval(start: start, end: end)
            
//            let dateIsInInterval: Bool = dateInterval.contains(date) // true
            
            return dateInterval.contains(date)
        }
        return days.first
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendanceCell") as! AttendanceTableViewCell
        cell.borderColor = currentBorderColor
        cell.event = filteredEvents[indexPath.row]
//        cell.attendance = currentDataSource[indexPath.row]
        return cell
    }
}
