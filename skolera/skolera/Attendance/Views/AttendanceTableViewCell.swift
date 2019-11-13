//
//  AttendanceTableViewCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/12/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    
    
    //MARK: - Variables
    var borderColor: UIColor!{
        didSet{
            if borderColor != nil
            {
                borderView.backgroundColor = borderColor
            }
        }
    }
    var attendance: Attendance!{
        didSet{
            if attendance != nil{
                let calendar = Calendar.current
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en")
                formatter.dateFormat = "MMM"
                let day = calendar.component(.day, from: attendance.date)
                let month = formatter.string(from: attendance.date)
                dayLabel.text = "\(day)"
                monthLabel.text = month
                messageLabel.text = attendance.comment ?? "No description available".localized
            }
        }
    }
    var event: StudentEvent! {
        didSet{
            if event != nil{
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                dateFormatter.locale = Locale(identifier: "en")
                let date = dateFormatter.date(from:self.event.startDate)
                let components = calendar.dateComponents([.year, .month, .day, .hour], from: date!)
                let day = components.day!
                dayLabel.text = "\(day)"
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en")
                formatter.dateFormat = "MMM"
                monthLabel.text = formatter.string(from: date!)
                messageLabel.text = event.description ?? ""
                titleLabel.text = self.event.title
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
