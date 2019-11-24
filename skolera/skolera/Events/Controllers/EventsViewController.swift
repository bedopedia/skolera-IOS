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

class EventsViewController: UIViewController, NVActivityIndicatorViewable, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    
    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
//    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    @IBOutlet weak var createEventButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cVCalendarView: CVCalendarView!
    @IBOutlet var menuView: CVCalendarMenuView!
    
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
    var maxHeight = CGFloat(224)
    var minHeight = CGFloat(48)
    var previousScrollOffset: CGFloat = 0
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        createEventButton.layer.borderColor = #colorLiteral(red: 0.1580090225, green: 0.7655162215, blue: 0.3781598806, alpha: 1)
        createEventButton.layer.borderWidth = 1
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // Appearance delegate [Unnecessary]
        self.cVCalendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.cVCalendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.cVCalendarView.calendarDelegate = self
        
        self.cVCalendarView!.changeDaysOutShowingState(shouldShow: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getEvents()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        cVCalendarView.commitCalendarViewUpdate()
        cVCalendarView.contentController.refreshPresentedMonth()
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func todayMonthView() {
        self.cVCalendarView.toggleCurrentDayView()
    }
    
    @IBAction func createNewEvent() {
        let createEventVC = CreateEventViewController.instantiate(fromAppStoryboard: .Events)
        createEventVC.child = child
        self.navigationController?.pushViewController(createEventVC, animated: true)
    }
    
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getEvents()
        refreshControl.endRefreshing()
    }
    
    func updateCurrentMonthLabel(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first?.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "MMMM yyyy"
        currentMonthLabel.text = formatter.string(from: date!)
    }
    
    func getEvents() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getEventsAPI(userId: child.userId, startDate: "2010-03-04T00:00:00.000Z", endDate: "2030-03-04T00:00:00.000Z") { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    debugPrint(result)
                    self.events = result.map{ StudentEvent($0) }
                    self.filteredEvents = self.events
                    self.academicCount = self.events.filter{ $0.type.elementsEqual("academic") }.count
                    self.eventsCount = self.events.filter{ $0.type.elementsEqual("event") }.count
                    self.vacationsCount = self.events.filter{ $0.type.elementsEqual("vacations") }.count
                    self.personalCount = self.events.filter{ $0.type.elementsEqual("personal") }.count
//                    reload calendar data
                    self.cVCalendarView.contentController.refreshPresentedMonth()
                    self.tableView.reloadData()
                    self.eventsCollectionView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
//    MARK:- Calendar methods
    func presentationMode() -> CalendarMode {
        .monthView
    }
    
    func firstWeekday() -> Weekday {
        Weekday.sunday
    }

    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        if let studentEvent = getEventForDate(optionalDate: dayView.date.convertedDate()) {
            debugPrint(dayView.date.convertedDate(), studentEvent.endDate!)
            return true
        } else {
            return false
        }

    }
    
    func getEventForDate(optionalDate: Date!) -> StudentEvent? {
//        debugPrint("opt", optionalDate)
        guard let date = optionalDate else {
            return nil
        }
        let days = events.filter { (event) -> Bool in
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
            //            formatter.string(from: )
            let start: Date = formatter.date(from: event.startDate!)!
            let end: Date = formatter.date(from: event.endDate!)!
            guard start < end else {
                return false
            }
            let dateInterval: DateInterval = DateInterval(start: start, end: end)
            //            let dateIsInInterval: Bool = dateInterval.contains(date) // true
            return dateInterval.contains(date)
        }
        return days.first
    }
//    changes the default color (used for the current day in calendar)
    func dotMarkerColor() -> UIColor {
        return .blue
    }
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return numberOfDots(dayView: dayView)
    }
    func numberOfDots(dayView: DayView) -> [UIColor] {
        if let studentEvent = getEventForDate(optionalDate: dayView.date.convertedDate()!) {
            return [UIColor.blue]
        } else {
            return []
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool {
        return false
    }
//    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
//        return CGFloat(16)
//    }
//    func dayLabelWeekdayFont() -> UIFont {
//        UIFont.systemFont(ofSize: 18)
//    }
//    func dayLabelPresentWeekdayHighlightedTextSize() -> CGFloat {
//        CGFloat(18)
//    }
    func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat {
        return 16
//        return  dayView.dayLabel.frame.maxY + 16
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
        cVCalendarView!.changeDaysOutShowingState(shouldShow: true)
    }
//    func setupDotMarkerFor(event: StudentEvent?) {
//
//            if let day = event {
//                switch day.type {
//                case "academic":
//                    dotMarkerView.backgroundColor = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1)
//                case "event":
//                    dotMarkerView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1)
//                case "vacations":
//                    dotMarkerView.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1)
//                case "personal":
//                    dotMarkerView.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1)
//                default:
//                    dotMarkerView.backgroundColor = .black
//                }
//            }
//    }
    
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

extension EventsViewController {
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
        cVCalendarView.changeMode(percentage == 0 ? .weekView : .monthView)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: UInt64(0.5))) {
            UIView.setAnimationsEnabled(true)
        }
    }
}


extension EventsViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
        cell.setupDayLabel(cellState: cellState)
//        cell.setupDotMarkerFor(event: getEventForDate(date: date), forCellState: cellState)
        return cell
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: Date(dateString: "1-1-2000", format: "d-M-y"), endDate: Date(dateString: "1-1-2026", format: "d-M-y"), generateInDates: .forAllMonths, generateOutDates: .off)
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        updateCurrentMonthLabel(from: visibleDates)
    }
//    func getEventForDate(optionalDate: Date!) -> StudentEvent? {
//        guard let date = optionalDate else {
//            return nil
//        }
//        let days = events.filter { (event) -> Bool in
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "en")
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
//            //            formatter.string(from: )
//            let start: Date = formatter.date(from: event.startDate!)!
//            let end: Date = formatter.date(from: event.endDate!)!
//            guard start < end else {
//                return false
//            }
//            let dateInterval: DateInterval = DateInterval(start: start, end: end)
//            //            let dateIsInInterval: Bool = dateInterval.contains(date) // true
//            return dateInterval.contains(date)
//        }
//        return days.first
//    }
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
