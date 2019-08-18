//
//  EventsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import JTAppleCalendar

class EventsViewController: UIViewController {
    
    @IBOutlet weak var weekDaysStackView: UIStackView!
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var createEventButton: UIButton!
    
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
    var currentBorderColor: UIColor!
    let today = Date()
    
    
    var oldSelectedEventsPosition: Int = -1
    var selectedEventsPosition: Int = 0
    
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
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleToToday() {
        calendarView.scrollToDate(today)
    }
    
    @IBAction func createNewEvent() {
        
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
}

extension EventsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventTypeCollectionViewCell", for: indexPath) as! EventTypeCollectionViewCell
        cell.bottomBar.isHidden = indexPath.row != selectedEventsPosition
        cell.cellNumber = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width / 3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedEventsPosition = indexPath.row
        oldSelectedEventsPosition = selectedEventsPosition
        selectedEventsPosition = indexPath.row
        collectionView.reloadItems(at: [.init(row: oldSelectedEventsPosition, section: 0), .init(row: selectedEventsPosition, section: 0)])
//        collectionView.reloadData()
    }
    
}

extension EventsViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
        cell.setupDayLabel(cellState: cellState)
//        cell.setupDotMarker(attendance: getAttendanceForDate(date: date), forCellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: Date(), endDate: today, generateInDates: .forAllMonths, generateOutDates: .off)
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
}
