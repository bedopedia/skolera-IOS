//
//  AssignmentTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var dueMonthLabel: UILabel!
    @IBOutlet weak var assignmentDateView: UIView!
    @IBOutlet weak var assignmentClockImage: UIImageView!
    @IBOutlet weak var assignmentDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var leftView: UIView!
    
    let yellowColor = #colorLiteral(red: 0.5019607843, green: 0.3764705882, blue: 0.1803921569, alpha: 1)
    let greenColor = #colorLiteral(red: 0.1450980392, green: 0.6588235294, blue: 0.2784313725, alpha: 1)
    let redColor = #colorLiteral(red: 0.8509803922, green: 0.1058823529, blue: 0.0862745098, alpha: 1)
    
    var assignment: FullAssignment! {
        didSet {
            titleLabel.text = assignment.name
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
            let assignDate = dateFormatter.date(from: assignment.startAt)
            let endDate = dateFormatter.date(from: assignment.endAt)
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "dd MMM YYYY"
            if Language.language == .arabic {
                publishDateLabel.text = "نشر " + newDateFormat.string(from: assignDate!)
            } else {
                publishDateLabel.text = "published \(newDateFormat.string(from: assignDate!))"
            }
            newDateFormat.dateFormat = "dd"
            dueDayLabel.text = newDateFormat.string(from: endDate!)
            newDateFormat.dateFormat = "MMM"
            dueMonthLabel.text = newDateFormat.string(from: endDate!)
            
            if let assignStringDate = assignment.endAt {
                assignmentDateView.isHidden = false
                assignmentDateLabel.isHidden = false
                assignmentClockImage.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
                let assignDate = dateFormatter.date(from: assignStringDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "h:mm a"
                assignmentDateLabel.text = newDateFormat.string(from: assignDate!)
                if assignment.state.elementsEqual("running") {
                    assignmentDateLabel.textColor = greenColor
                    assignmentClockImage.image = #imageLiteral(resourceName: "ic_clock_green")
                    leftView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.937254902, blue: 0.8039215686, alpha: 0.3)
                    dueDayLabel.textColor = greenColor
                    dueMonthLabel.textColor = greenColor
                } else if assignment.state.elementsEqual("done") {
                    assignmentDateLabel.textColor = redColor
                    assignmentClockImage.image = #imageLiteral(resourceName: "ic_clock_red")
                    leftView.backgroundColor = #colorLiteral(red: 1, green: 0.8784313725, blue: 0.8745098039, alpha: 0.25)
                    dueDayLabel.textColor = redColor
                    dueMonthLabel.textColor = redColor
                } else {
                    assignmentDateLabel.textColor = yellowColor
                    assignmentClockImage.image = #imageLiteral(resourceName: "ic_brown_clock")
                    leftView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.8392156863, alpha: 0.3)
                    dueDayLabel.textColor = yellowColor
                    dueMonthLabel.textColor = yellowColor
                }
            } else {
                assignmentDateView.isHidden = true
                assignmentDateLabel.isHidden = true
                assignmentClockImage.isHidden = true
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
