//
//  AttendanceViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/11/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import CVCalendar

class AttendanceViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
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
    var currentDataSource = [Attendance]()
    var currentBorderColor: UIColor!
    let today = Date()
    var offDays =  Set <weekDays> ()
    var maxHeight = CGFloat(224)
    var minHeight = CGFloat(48)
    var previousScrollOffset: CGFloat = 0
    var currentCalendar: Calendar?
    var attendancesDict: [String: [Attendance]] = [:]
    
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
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        self.calendarView!.changeDaysOutShowingState(shouldShow: true)
        
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.timeZone = TimeZone.current
        setUpAttendances()
        updateCurrentLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        commitCalendarViews()
    }

    func getAttendanceForDate(date: Date) -> Attendance? {
        let days = child.attendances.filter { (attendance) -> Bool in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter.string(from: attendance.date) == formatter.string(from: date)
        }
        return days.first
    }
    
    func calendar() -> Calendar? {
        currentCalendar = Calendar(identifier: .gregorian)
        currentCalendar?.timeZone = TimeZone(identifier: "UTC")!
        return currentCalendar
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func commitCalendarViews() {
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
//        let dotDate = dayView.date.convertedDate() ?? Date()
//        let index = events.firstIndex { (studentEvent) -> Bool in
//             studentEvent.startDate.toISODate()?.compare(toDate: dotDate.inDefaultRegion(), granularity: .day) == .orderedSame
//        }
//        if let arrayIndex = index {
//            let frame = tableView.rectForRow(at: IndexPath.init(row: arrayIndex, section: 0))
//            self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: frame.minY)
//        }
    }
    
    func presentationMode() -> CalendarMode {
        .monthView
    }
    
    func firstWeekday() -> Weekday {
        Weekday.sunday
    }
    func setUpAttendances() {
//        attendancesDict = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = .current
        for attendance in self.child.attendances {
            let dateString = formatter.string(from: attendance.date)
            if let priorAttendances = attendancesDict[dateString] {
                var tempAttendances = priorAttendances
                tempAttendances.append(attendance)
                attendancesDict[dateString] = tempAttendances
            } else {
                attendancesDict[dateString] = [attendance]
            }
        }
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        var dateString = ""
        if dayView.date.month == 0 {
            dateString = "\(dayView.date.year)/12/\(String(format: "%02d", dayView.date.day))"
        } else {
            dateString = "\(dayView.date.year)/\((String(format: "%02d", dayView.date.month)))/\(String(format: "%02d", dayView.date.day))"
        }
//        debugPrint("\(dayView.date.month)")
        if let attendances = attendancesDict[dateString], !attendances.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func dotMarkerColor() -> UIColor {
        return .black
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return dotsColors(dayView: dayView)
    }
    func dotsColors(dayView: DayView) -> [UIColor] {
        var dateString = ""
        if dayView.date.month == 0 {
            dateString = "\(dayView.date.year)/12/\(String(format: "%02d", dayView.date.day))"
        } else {
            dateString = "\(dayView.date.year)/\((String(format: "%02d", dayView.date.month)))/\(String(format: "%02d", dayView.date.day))"
        }
        if let attendances = attendancesDict[dateString], !attendances.isEmpty, let attendance = attendances.first {
            switch attendance.status {
            case "present":
                return [UIColor.appColors.green]
            case "absent":
                return [UIColor.appColors.red]
            case "late":
                return [UIColor.appColors.purple]
            case "excused":
                return [UIColor.appColors.orange]
            default:
                return [UIColor.appColors.greyNotTaken]
            }
        }
        return [UIColor.blue]
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        false
    }
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        false
    }
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
            return 16
    //        return  dayView.dayLabel.frame.maxY + 16
    }
    func shouldAnimateResizing() -> Bool {
        return true
    }
    
    func toggleState (state: CalendarMode) {
        calendarView.changeMode(state)
        calendarView!.changeDaysOutShowingState(shouldShow: true)
    }
    //MARK: - Actions
    
    @IBAction func toggleToToday() {
        self.calendarView.toggleCurrentDayView()
        updateCurrentLabel()
    }
    
    @IBAction func switchToLate(_ sender: UIButton) {
        lateBottomBorderView.isHidden = false
        excusedBottomBorderView.isHidden = true
        absentBottomBorderView.isHidden = true
        loadLateDays()
    }
    fileprivate func updateCurrentLabel() {
        if let currentCalendar = currentCalendar {
            currentMonthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
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
//MARK: - CVCalendar Convenience APIs
extension AttendanceViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        guard let currentCalendar = currentCalendar else { return }
        var components = Manager.componentsForDate(Date(), calendar: currentCalendar) // from today
        components.month! += offset
        let resultDate = currentCalendar.date(from: components)!
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else { return }
        currentMonthLabel.text = CVDate(date: date, calendar: currentCalendar).globalDescription
//        self.cVCalendarView.contentController.refreshPresentedMonth()
    }
    
    func didShowPreviousMonthView(_ date: Date) {
        guard let currentCalendar = currentCalendar else { return }
        currentMonthLabel.text = CVDate(date: date, calendar: currentCalendar).globalDescription
    }
  
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
  
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
}

extension AttendanceViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        let absoluteTop: CGFloat = 0
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y <= 0
        if canAnimateView(scrollView) {
            // Calculate new View height
            var newHeight = self.calendarHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeight, self.calendarHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeight, self.calendarHeightConstraint.constant + abs(scrollDiff))
            }
            
            // View needs to animate
            if newHeight != self.calendarHeightConstraint.constant {
                self.calendarHeightConstraint.constant = newHeight
                if isScrollingUp {
                    self.expandView()
                    self.setScrollPosition(0)
                } else {
                    self.setScrollPosition(self.previousScrollOffset)
                    self.updateView()
                }
            }
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeight - self.minHeight
        let midPoint = self.minHeight + (range / 2)
        if self.calendarHeightConstraint.constant > midPoint {
            self.expandView()
        } else {
            self.collapseView()
        }
    }
    
    func canAnimateView(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when View is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.calendarHeightConstraint.constant - minHeight
        
        // Make sure that when View is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    public func collapseView() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.calendarHeightConstraint.constant = self.minHeight
            self.updateView()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandView() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarHeightConstraint.constant = self.maxHeight
            self.updateView()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateView() {
        let range = self.maxHeight - self.minHeight
        let openAmount = self.calendarHeightConstraint.constant - self.minHeight
        let percentage = openAmount / range
        calendarHeightConstraint.constant = minHeight + (range * percentage)
        UIView.setAnimationsEnabled(false)
        calendarView.changeMode(percentage == 0 ? .weekView : .monthView)
        UIView.setAnimationsEnabled(true)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0))) {
//            UIView.setAnimationsEnabled(true)
//        }
    }
}
