//
//  AssignmentCourseTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 6/12/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AssignmentCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImageView: UIImageView! {
        didSet {
            self.courseImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var assignmentDateView: UIView!{
        didSet {
            assignmentDateView.layer.cornerRadius = assignmentDateView.frame.height / 2
            assignmentDateView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var assignmentClockImage: UIImageView!
    @IBOutlet weak var assignmentDateLabel: UILabel!
    @IBOutlet weak var numberOfAssignmentLabel: UILabel!
    @IBOutlet var dateViewHeightConstraint: NSLayoutConstraint!
    
    var course: AssignmentCourse!{
        didSet{
            courseImageView.isHidden = false
            subjectImageLabel.clipsToBounds = true
            subjectImageLabel.layer.masksToBounds = true
            subjectImageLabel.text = getText(name: course.courseName)
            courseTitle.text = course.courseName
            if let count = course.runningAssignmentsCount, count > 0 {
                assignmentName.text = course.assignmentName
                numberOfAssignmentLabel.text = "\(count)"
            } else {
                assignmentName.text = "No active assignments currently".localized
                numberOfAssignmentLabel.text = ""
            }
            if let _ = course.nextAssignmentDate {
                dateViewHeightConstraint.constant = 24
                assignmentDateView.isHidden = false
                assignmentDateLabel.isHidden = false
                assignmentClockImage.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let assignDate = dateFormatter.date(from: course.nextAssignmentDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
                assignmentDateLabel.text = newDateFormat.string(from: assignDate!)
                if let status = course.assignmentState, status.elementsEqual("running") {
                    assignmentDateLabel.textColor = #colorLiteral(red: 0.1580090225, green: 0.7655162215, blue: 0.3781598806, alpha: 1)
                    assignmentClockImage.image = #imageLiteral(resourceName: "ic_clock_green")
                } else {
                    assignmentDateLabel.textColor = #colorLiteral(red: 0.8509803922, green: 0.1058823529, blue: 0.0862745098, alpha: 1)
                    assignmentClockImage.image = #imageLiteral(resourceName: "ic_clock_red")
                }
            } else {
                assignmentDateView.isHidden = true
                assignmentDateLabel.isHidden = true
                assignmentClockImage.isHidden = true
                dateViewHeightConstraint.constant = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        courseImageView.layer.shadowColor = UIColor.clear.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getText(name: String) -> String {
        let shortcut = name.replacingOccurrences(of: "&", with: "")
        if shortcut.split(separator: " ").count == 1 {
            //            return "\(shortcut.first!)"
            return String(shortcut.prefix(2))
        } else {
            return "\(shortcut.split(separator: " ")[0].first ?? Character(" "))\(shortcut.split(separator: " ")[1].first ?? Character(" "))"
        }
        
    }
    
    

}
