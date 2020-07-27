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
import SwiftDate

class TimetableViewController: UIViewController, EventDataSource{
    //MARK: - Variables
    let calendar = Calendar.current
    var today : Date!
    var tomorrow : Date!
    var todayEvents : [EventDescriptor]!    
    var tomorrowEvents : [EventDescriptor]!
    var child : Actor!
    var timeslots: [TimeSlot]!
    var actor: Actor!
    
    //MARK: - Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var dayView: DayView!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        let region = Region(calendar: Calendars.gregorian, zone: Zones.init(rawValue: UserDefaults.standard.string(forKey: TIMEZONE)!)!, locale: Locales.english)
        let dateInRegion = DateInRegion().convertTo(region: region)
        today = dateInRegion.date.to(timeZone: TimeZone.init(identifier: UserDefaults.standard.string(forKey: TIMEZONE)!)!, from: .current)
        debugPrint("TODAY: ", today.dateComponents.day, dateInRegion.dateComponents.hour, dateInRegion.dateComponents.day, region.timeZone)
        tomorrow = today.add(TimeChunk.dateComponents(days: 1))
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first ?? Character(" "))\(child.lastname.first ?? Character(" "))", textSize: 14)
        } else {
            childImageView.childImageView(url: actor.avatarUrl, placeholder: "\(actor.firstname.first ?? Character(" "))\(actor.lastname.first ?? Character(" "))", textSize: 14)
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
        statusSegmentControl.setTitleTextAttributes([.foregroundColor: getMainColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        statusSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        if isParent() {
            if #available(iOS 13.0, *) {
                statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            } else {
                statusSegmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            }
        } else {
            if getUserType() == UserType.teacher {
                if #available(iOS 13.0, *) {
                    statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
                } else {
                    statusSegmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
                }
            } else {
                if #available(iOS 13.0, *) {
                    statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                } else {
                    statusSegmentControl.tintColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
                }
            }
            
        }
        
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK :- Actions
    @IBAction func switchTimeTable(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            dayView.state?.move(to: today)
        case 1:
            dayView.state?.move(to: tomorrow)
        default:
            dayView.state?.move(to: today)
        }
    }
    
    private func getTodayName() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: today)
        debugPrint("Today name: " , dayInWeek)
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
    private func getTodayEvents() -> [EventDescriptor]  //sets ui
    {
        var result =  [EventDescriptor]()
        if timeslots != nil {
            let slots = timeslots.filter { (timeslot) -> Bool in
                timeslot.day == getTodayName()  //filters on the name of week not the whole date
            }
            //random index to start from
            var randomIndex = Int(arc4random_uniform(UInt32(UIColor.appColors.timeSlotsColors.count)))
            for timeslot in slots {
                let event = Event()
                event.startDate = timeslot.from.dateBySet([.year: today.dateComponents.year ?? 0, .month: today.dateComponents.month ?? 0, .day: today.dateComponents.day ?? 0]) ?? Date()
                debugPrint("Start Date: ", event.startDate)
                event.endDate = timeslot.to.dateBySet([.year: today.dateComponents.year ?? 0, .month: today.dateComponents.month ?? 0, .day: today.dateComponents.day ?? 0]) ?? Date()
                debugPrint("End Date: ",  event.endDate)
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
                event.startDate = timeslot.from.dateBySet([.year: tomorrow.dateComponents.year ?? 0, .month: tomorrow.dateComponents.month ?? 0, .day: tomorrow.dateComponents.day ?? 0]) ?? Date()
                event.endDate = timeslot.to.dateBySet([.year: tomorrow.dateComponents.year ?? 0, .month: tomorrow.dateComponents.month ?? 0, .day: tomorrow.dateComponents.day ?? 0]) ?? Date()
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
        let attributedCourseName = NSAttributedString(string: courseName, attributes: [NSAttributedStringKey.font :UIFont.systemFont(ofSize: 18, weight: .bold), NSAttributedStringKey.foregroundColor : UIColor.appColors.dark])
        let attributedGroup = NSAttributedString(string: "\nGroup : "+group, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .bold), NSAttributedStringKey.foregroundColor : UIColor.appColors.greyNotTaken])
        let result = NSMutableAttributedString(attributedString: attributedCourseName)
        result.append(attributedGroup)
        return result.attributedSubstring(from: NSMakeRange(0, result.string.count))
    }
    //MARK:- Delegates
    func eventsForDate(_ date: Date) -> [EventDescriptor] { //ui setting
        if (date.isToday) {
            return todayEvents
        } else if (date.isTomorrow) {
            return tomorrowEvents
        } else {
            return []
        }
    }
}

extension Date {
    func to(timeZone outputTimeZone: TimeZone, from inputTimeZone: TimeZone) -> Date {
         let delta = TimeInterval(outputTimeZone.secondsFromGMT(for: self) - inputTimeZone.secondsFromGMT(for: self))
         return addingTimeInterval(delta)
    }
}
