//
//  AttendanceViewController+TabelViewDelegates.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/15/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit

extension AttendanceViewController: UITableViewDelegate,UITableViewDataSource{
    var lateDays: [Attendance]{
        let result =  child.attendances.filter({ (attendance) -> Bool in
            return attendance.status == "late"
        })
        lateDaysNumberLabel.text = "\(result.count)"
        return result
    }
    var absentDays: [Attendance]{
        let result =  child.attendances.filter({ (attendance) -> Bool in
            return attendance.status == "absent"
        })
        absentDaysNumberLabel.text = "\(result.count)"
        return result
    }
    var excusedDays: [Attendance]{
        
        let result = child.attendances.filter({ (attendance) -> Bool in
            return attendance.status == "excused"
        })
        excusedDaysNumberLabel.text = "\(result.count)"
        return result
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendanceCell") as! AttendanceTableViewCell
        cell.borderColor = currentBorderColor
        cell.attendance = currentDataSource[indexPath.row]
        return cell
    }
    func loadLateDays()
    {
        currentDataSource = lateDays
        currentBorderColor = UIColor.appColors.purple
        tableView.reloadData()
    }
    func loadAbsentDays()
    {
        currentDataSource = absentDays
        currentBorderColor = UIColor.appColors.red
        tableView.reloadData()
    }
    func loadExcusedDays()
    {
        currentDataSource = excusedDays
        currentBorderColor = UIColor.appColors.orange
        tableView.reloadData()
    }
    
}
