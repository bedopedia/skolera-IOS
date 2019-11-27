//
//  AttendanceViewController+CalendarDelegates.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/25/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import JTAppleCalendar
//extension AttendanceViewController : JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
//    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
//    }
//    
//    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCollectionViewCell
//        cell.setupDayLabel(cellState: cellState)
//        cell.setupDotMarker(attendance: getAttendanceForDate(date: date), forCellState: cellState)
//        return cell
//    }
//    
//    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
//        let parameters = ConfigurationParameters(startDate: (child.attendances.first?.date) ?? today , endDate: today, generateInDates: .forAllMonths, generateOutDates: .off)
//        return parameters
//    }
//    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
//        updateCurrentMonthLabel(from: visibleDates)
//    }
//    func getAttendanceForDate(date: Date) -> Attendance?
//    {
//        let days = child.attendances.filter { (attendance) -> Bool in
//            let formatter = DateFormatter()
//            formatter.locale = Locale(identifier: "en")
//            formatter.dateFormat = "yyyy-MM-dd"
//            return formatter.string(from: attendance.date) == formatter.string(from: date)
//        }
//        return days.first
//    }
//}
