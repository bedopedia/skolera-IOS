//
//  CalendarCollectionViewCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/25/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Device_swift

class CalendarCollectionViewCell: JTAppleCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dotMarkerView: UIView!
    
    let today = Date()
    func setupDayLabel(cellState : CellState)
    {
        dayLabel.text = nil
        dayLabel.backgroundColor = nil
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "yyyy-MM-dd"
        if cellState.dateBelongsTo == .thisMonth
        {
            dayLabel.text = cellState.text
        }
        
        if formatter.string(from: cellState.date) == formatter.string(from: today)
        {
            let deviceType = UIDevice.current.deviceType
            switch deviceType {
            case .simulator:
//                labelWidthConstraint.constant = 30
//                labelHeightConstraint.constant = 30
                dayLabel.font.withSize(12)
                debugPrint("sem")
            case .iPad:
                debugPrint("testok")
            case .iPhone4:
                debugPrint("test")
            default :
                debugPrint("fail")
            }
            dayLabel.rounded(foregroundColor: UIColor.white, backgroundColor: UIColor.appColors.green)
        }
        else
        {
            formatter.dateFormat = "EEEE"
            let day = formatter.string(from: cellState.date)
            if day == "Friday" || day == "Saturday"
            {
                dayLabel.textColor = UIColor.appColors.offDaysColor
            }
            else
            {
                dayLabel.textColor = UIColor.black
            }
        }
    }
    func setupDotMarker(attendance: Attendance?, forCellState cellState: CellState) {
        dotMarkerView.isHidden = true
        dotMarkerView.layer.masksToBounds = false
        dotMarkerView.layer.cornerRadius = dotMarkerView.frame.height / 2
        if cellState.dateBelongsTo == .thisMonth
        {
            if let day = attendance
            {
                dotMarkerView.isHidden = false
                switch day.status
                {
                case "present":
                    dotMarkerView.backgroundColor = UIColor.appColors.green
                case "absent":
                    dotMarkerView.backgroundColor = UIColor.appColors.red
                case "late":
                    dotMarkerView.backgroundColor = UIColor.appColors.purple
                case "excused":
                    dotMarkerView.backgroundColor = UIColor.appColors.orange
                default:
                    dotMarkerView.backgroundColor = UIColor.appColors.greyNotTaken
                }
            }
        }
    }
    
    func setupDotMarkerFor(event: StudentEvent?, forCellState cellState: CellState) {
        dotMarkerView.isHidden = true
        dotMarkerView.layer.masksToBounds = false
        dotMarkerView.layer.cornerRadius = dotMarkerView.frame.height / 2
        if cellState.dateBelongsTo == .thisMonth {
            if let day = event {
                dotMarkerView.isHidden = false
                switch day.type {
                case "academic":
                    dotMarkerView.backgroundColor = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1)
                case "event":
                    dotMarkerView.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1)
                case "vacations":
                    dotMarkerView.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1)
                case "personal":
                    dotMarkerView.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1)
                default:
                    dotMarkerView.backgroundColor = .black
                }
            }
        }
    }
}
