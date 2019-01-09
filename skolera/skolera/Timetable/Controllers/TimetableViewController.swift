//
//  TimetableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 4/22/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import CalendarKit
import DateToolsSwift
class TimetableViewController: UIViewController, EventDataSource{
    //MARK: - Variables
    let calendar = Calendar.current
    var today : Date!
    var tomorrow : Date!
    var todayEvents : [EventDescriptor]!
    
    var tomorrowEvents : [EventDescriptor]!
    var child : Child!
    var timeslots: [TimeSlot]!
    
    //MARK: - Outlets
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var dayView: DayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        today = Date().start(of: .day).add(TimeChunk.dateComponents(hours: 2))
        tomorrow = today.add(TimeChunk.dateComponents(days: 1))
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        if (timeslots) != nil{
            todayEvents = getTodayEvents()
            tomorrowEvents = getTomorrowEvents()
        }
        dayView.dataSource = self
        dayView.reloadData()
        dayView.autoScrollToFirstEvent = true
        dayView.isHeaderViewVisible = false
        let calendarStyle = CalendarStyle()
        calendarStyle.timeline.dateStyle = .twelveHour
        calendarStyle.timeline.timeIndicator.dateStyle = .twelveHour
        dayView.updateStyle(calendarStyle)
        dayView.scrollToFirstEventIfNeeded()

    }

    //MARK :- Actions
    @IBAction func switchTimeTable(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            dayView.state?.move(to: today)
            print("switched to today")
        case 1:
            dayView.state?.move(to: tomorrow)
            print("switched to tomorrow")
        default:
            dayView.state?.move(to: today)
        }
    }
    
    private func getTodayName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: today)
        return dayInWeek
    }
    
    private func getTomorrowName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: tomorrow)
        return dayInWeek
    }
    //MARK:- methods:
    private func getTodayEvents() -> [EventDescriptor]
    {
        var result =  [EventDescriptor]()
        if timeslots != nil
        {
            let slots = timeslots.filter { (timeslot) -> Bool in
                timeslot.day == getTodayName()
            }
            //random index to start from
            var randomIndex = Int(arc4random_uniform(UInt32(UIColor.appColors.timeSlotsColors.count)))
            for timeslot in slots
            {
                let event = Event()
                event.startDate = timeslot.from.add(TimeChunk.dateComponents(days:(timeslot.from.daysEarlier(than: today) + 1)))
                event.endDate = timeslot.to.add(TimeChunk.dateComponents(days:(timeslot.to.daysEarlier(than: today) + 1)))
                event.attributedText = getAttributedString(text: timeslot.courseName)
                event.color = UIColor.appColors.timeSlotsColors[randomIndex]
                randomIndex += 1
                randomIndex %= UIColor.appColors.timeSlotsColors.count
                result.append(event)
            }
        }
        return result
    }
    private func getTomorrowEvents() -> [EventDescriptor]
    {
        var result =  [EventDescriptor]()
        if timeslots != nil
        {
            
            let slots = timeslots.filter { (timeslot) -> Bool in
                timeslot.day == getTomorrowName()
            }
            for timeslot in slots
            {
                let event = Event()
                event.startDate = timeslot.from.add(TimeChunk.dateComponents(days:(timeslot.from.daysEarlier(than: today) + 2)))
                event.endDate = timeslot.to.add(TimeChunk.dateComponents(days:(timeslot.to.daysEarlier(than: today) + 2)))
                event.attributedText = getAttributedString(text: timeslot.courseName)
                //random index to start from
                var randomIndex = Int(arc4random_uniform(UInt32(UIColor.appColors.timeSlotsColors.count)))
                randomIndex += 1
                randomIndex %= UIColor.appColors.timeSlotsColors.count
                event.color = UIColor.appColors.timeSlotsColors[randomIndex]
                result.append(event)
            }
        }
        return result
    }
    
    private func getAttributedString(text : String) -> NSAttributedString
    {
        var courseName : String = ""
        var group : String = ""
        if let pos = text.index(of: "(")
        {
            courseName = String(text[..<pos])
            let afteropeningbracket = text.index(pos, offsetBy: 1)
            let closingbracket = text.index(text.endIndex, offsetBy: -2)
            group = String(text[afteropeningbracket...closingbracket])
        }
        let attributedCourseName = NSAttributedString(string: courseName, attributes: [NSAttributedStringKey.font : UIFont.init(name: "CircularStd-Bold" , size: 18), NSAttributedStringKey.foregroundColor : UIColor.appColors.dark])
        let attributedGroup = NSAttributedString(string: "\nGroup : "+group, attributes: [NSAttributedStringKey.font : UIFont.init(name: "CircularStd-Book" , size: 14), NSAttributedStringKey.foregroundColor : UIColor.appColors.greyNotTaken])
        let result = NSMutableAttributedString(attributedString: attributedCourseName)
            result.append(attributedGroup)
        return result.attributedSubstring(from: NSMakeRange(0, result.string.count))
    }
    //MARK:- Delegates
    func eventsForDate(_ date: Date) -> [EventDescriptor] {
        if (date.isToday)
        {
            return todayEvents
        }
        else if (date.isTomorrow)
        {
            return tomorrowEvents
        }
        else
        {
            return []
        }
    }

}
