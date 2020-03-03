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
import CVCalendar
import SwiftDate
import SkeletonView

class EventsViewController: UIViewController, NVActivityIndicatorViewable, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cVCalendarView: CVCalendarView!
    @IBOutlet var menuView: CVCalendarMenuView!
    @IBOutlet var collectionViewTopConstraint: NSLayoutConstraint!
    
    enum weekDays : Int{
        case sunday = 0
        case monday = 1
        case tuesday = 2
        case wednesday = 3
        case thursday = 4
        case friday = 5
        case saturday = 6
    }
    
    var child : Actor!
    var currentBorderColor: UIColor = .black
    var oldSelectedEventsPosition: Int = -1
    var selectedEventsPosition: Int = 0
    var events: [StudentEvent] = []
    var filteredEvents: [StudentEvent] = []
    
    var academicCount = 0
    var eventsCount = 0
    var vacationsCount = 0
    var personalCount = 0
    var maxHeight = CGFloat(224)
    var minHeight = CGFloat(48)
    var previousScrollOffset: CGFloat = 0
//    private let refreshControl = UIRefreshControl()
    var currentCalendar: Calendar?
    var eventsDict: [String: [StudentEvent]] = [:]
    var firstScroll = true

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsDict = [:]
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child {
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        createEventButton.layer.borderColor = #colorLiteral(red: 0.1580090225, green: 0.7655162215, blue: 0.3781598806, alpha: 1)
        createEventButton.layer.borderWidth = 1
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.refreshControl = refreshControl
//        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // Appearance delegate [Unnecessary]
        self.cVCalendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.cVCalendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.cVCalendarView.calendarDelegate = self
        
        self.cVCalendarView!.changeDaysOutShowingState(shouldShow: true)
        
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.timeZone = TimeZone.current
        updateCurrentLabel(currentCalendar: self.currentCalendar, label: self.currentMonthLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.showAnimatedSkeleton()
        getEvents()
    }
    
    func getEvents() {
        getEventsAPI(userId: child.id, startDate: "2010-03-04T00:00:00.000Z", endDate: "2030-03-04T00:00:00.000Z") { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.events = result.map{ StudentEvent($0) }
                    self.filteredEvents = self.events
                    self.academicCount = self.events.filter{ $0.type.elementsEqual("academic") }.count
                    self.eventsCount = self.events.filter{ $0.type.elementsEqual("event") }.count
                    self.vacationsCount = self.events.filter{ $0.type.elementsEqual("vacations") }.count
                    self.personalCount = self.events.filter{ $0.type.elementsEqual("personal") }.count
//                    select the first tab
                    self.selectAllEvents()
                    self.setUpEvents()
                    DispatchQueue.main.async {
                        commitCalendarViews(calendarView: self.cVCalendarView, menuView: self.menuView)
                    }
                    self.cVCalendarView.contentController.refreshPresentedMonth()
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                    self.tableView.reloadData()
                    self.eventsCollectionView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func setUpEvents() {
        eventsDict = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = .current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        for event in self.events {
            if let startDate = dateFormatter.date(from: event.startDate), let endDate = dateFormatter.date(from: event.endDate) {
                let difference =  Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
                for index in 0...difference {
                    let daysOffset = startDate.add(.init(seconds: 0, minutes: 0, hours: 0, days: index, weeks: 0, months: 0, years: 0))
                    let dateString = formatter.string(from: daysOffset)
                    if let priorEvents = eventsDict[dateString] {
                        var tempEvents = priorEvents
                        tempEvents.append(event)
                        eventsDict[dateString] = tempEvents
                    } else {
                        eventsDict[dateString] = [event]
                    }
                }
            }
        }
    }
//    MARK: - IBActions
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func todayMonthView() {
        self.cVCalendarView.toggleCurrentDayView()
//        updateCurrentLabel(currentCalendar: self.currentCalendar, label: self.currentMonthLabel)
    }
    
    @IBAction func createNewEvent() {
        let createEventVC = CreateEventViewController.instantiate(fromAppStoryboard: .Events)
        createEventVC.child = child
        self.navigationController?.pushViewController(createEventVC, animated: true)
    }
}
//    MARK:- Calendar extension
extension EventsViewController {
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
        if let studentEvents = eventsDict[getDateString(dayView)], let event = studentEvents.first {
            let index = events.firstIndex { (studentEvent) -> Bool in
                studentEvent.id == event.id
            }
            if let arrayIndex = index {
                if self.filteredEvents.count > arrayIndex {
                    self.tableView.scrollToRow(at: IndexPath(row: arrayIndex, section: 0), at: .middle, animated: true)
                }
            }
        }
    }
    
    func presentationMode() -> CalendarMode {
        .monthView
    }
    
    func firstWeekday() -> Weekday {
        Weekday.sunday
    }
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        if let events = eventsDict[getDateString(dayView)], !events.isEmpty {
            return true
        } else {
            return false
        }
    }
    func shouldAutoSelectDayOnWeekChange() -> Bool {
        false
    }
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        false
    }
    
//        changes the default color (used for the current day in calendar)
//    func dotMarkerColor() -> UIColor {
//        return .black
//    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return dotsColors(dayView: dayView)
    }
    
    //    func getEventsForDayView(dayView: DayView) -> [StudentEvent] {
    //        let dotDate = dayView.date.convertedDate() ?? Date()
    //        let dayEvents = events.filter({
    //            $0.startDate.toISODate()?.compare(toDate: dotDate.inDefaultRegion(), granularity: .day) == .orderedSame
    //        })
    //        return dayEvents
    //    }
    
    func dotsColors(dayView: DayView) -> [UIColor] {
        if let events = eventsDict[getDateString(dayView)], !events.isEmpty {
            if events.count == 1 {
                return [getEventColor(event: events.first!)]
            } else if events.count == 2 {
                return [getEventColor(event: events.first!), getEventColor(event: events[1])]
            } else {
                return [getEventColor(event: events.first!), getEventColor(event: events[1]), getEventColor(event: events[2])]
            }
        } else {
            return []
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
//    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
//        return CGFloat(8)
//    }
    
    //    func dayLabelWeekdayFont() -> UIFont {
    //        UIFont.systemFont(ofSize: 18)
    //    }
    //    func dayLabelPresentWeekdayHighlightedTextSize() -> CGFloat {
    //        CGFloat(18)
    //    }
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 16
    }
    func shouldAnimateResizing() -> Bool {
        return true
    }
    //    called at switching the whole page
    func toggleDateAnimationDuration() -> Double {
        return 0
    }
    
    func toggleState (state: CalendarMode) {
        cVCalendarView.changeMode(state)
        updateCurrentLabel(currentCalendar: currentCalendar, label: currentMonthLabel)
        cVCalendarView!.changeDaysOutShowingState(shouldShow: true)
    }
    
    func getEventColor(event: StudentEvent) -> UIColor {
        switch event.type {
        case "academic":
            return #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1)
        case "event":
            return #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1)
        case "vacations":
            return #colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1)
        case "personal":
            return #colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1)
        default:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        updateCurrentLabel(date.convertedDate()!, currentCalendar: currentCalendar, label: currentMonthLabel)
    }
        
    func didShowNextWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    
    func didShowPreviousWeekView(from startDayView: DayView, to endDayView: DayView) {
        print("Showing Week: from \(startDayView.date.day) to \(endDayView.date.day)")
    }
    
    func getIsoDate(dayView: DayView) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        return dateFormatter.string(from: dayView.date.convertedDate()!)
    }
}
//MARK: - Calendar appearance delegate
extension EventsViewController: CVCalendarViewAppearanceDelegate {
//    func dotMarkerColor() -> UIColor {
//        return #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
//    }
//    menu color
//    func dayOfWeekTextColor() -> UIColor { return .black }
//    func dayLabelSize(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> CGFloat {
//        return 8
//    }
//
//    func dayLabelWeekdayHighlightedTextSize() -> CGFloat {
//        20
//    }
//    func dayLabelPresentWeekdayTextSize() -> CGFloat {
//        return 12
//    }
//    func dayLabelPresentWeekdayHighlightedTextSize() -> CGFloat {
//        return 8
//    }
    func spaceBetweenDayViews() -> CGFloat { return 8 }
//    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 18) }
}
//MARK: - Collection view extension
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
    func selectAllEvents() {
        filteredEvents = events
        currentBorderColor = .black
        oldSelectedEventsPosition = selectedEventsPosition
        selectedEventsPosition = 0
        eventsCollectionView.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: .left, animated: true)
        eventsCollectionView.reloadItems(at: [.init(row: oldSelectedEventsPosition, section: 0), .init(row: selectedEventsPosition, section: 0)])
    }
}
//MARK:- Collapse Extension
extension EventsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if firstScroll {
            self.maxHeight = cVCalendarView.frame.height
            firstScroll = false
        }
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
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.cVCalendarView.changeMode(percentage == 0 ? .weekView : .monthView)
            self.cVCalendarView!.changeDaysOutShowingState(shouldShow: true)
            updateCurrentLabel(currentCalendar: self.currentCalendar, label: self.currentMonthLabel)
            self.cVCalendarView.contentController.refreshPresentedMonth()
            UIView.setAnimationsEnabled(true)
        }
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendanceCell") as! AttendanceTableViewCell
        cell.borderColor = currentBorderColor
        cell.hideSkeleton()
        cell.event = filteredEvents[indexPath.row]
        //        cell.attendance = currentDataSource[indexPath.row]
        return cell
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "attendanceCell"
    }
}

