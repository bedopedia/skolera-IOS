//
//  AssignmentCourseTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 6/12/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AssignmentCourseTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImageView: UIImageView!
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
    
    var course: AssignmentCourse!{
        didSet{
            courseImageView.isHidden = false
            subjectImageLabel.clipsToBounds = false
            courseImageView.layer.shadowColor = UIColor.appColors.green.cgColor
            courseImageView.layer.shadowOpacity = 0.3
            courseImageView.layer.shadowOffset = CGSize.zero
            courseImageView.layer.shadowRadius = 10
            courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
            subjectImageLabel.textAlignment = .center
            subjectImageLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: UIColor.appColors.green)
            subjectImageLabel.font = UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.semibold)
            subjectImageLabel.text = getText(name: course.courseName)
            courseTitle.text = course.courseName
            assignmentName.text = course.assignmentName == nil ? "No active assignments currently".localized : course.assignmentName
            if let assignStringDate = course.nextAssignmentDate {
                assignmentDateView.isHidden = false
                assignmentDateLabel.isHidden = false
                assignmentClockImage.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let assignDate = dateFormatter.date(from: course.nextAssignmentDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
                assignmentDateLabel.text = newDateFormat.string(from: assignDate!)
                if let status = course.assignmentState, status.elementsEqual("running") {
                    assignmentDateView.backgroundColor = #colorLiteral(red: 0.8247086406, green: 0.9359105229, blue: 0.8034248352, alpha: 1)
                    assignmentDateLabel.textColor = #colorLiteral(red: 0.1179271713, green: 0.2293994129, blue: 0.09987530857, alpha: 1)
                    assignmentClockImage.image = #imageLiteral(resourceName: "greenHour")
                } else {
                    assignmentDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
                    assignmentDateLabel.textColor = #colorLiteral(red: 0.4231846929, green: 0.243329376, blue: 0.1568627451, alpha: 1)
                    assignmentClockImage.image = #imageLiteral(resourceName: "1")
                }
            } else {
                assignmentDateView.isHidden = true
                assignmentDateLabel.isHidden = true
                assignmentClockImage.isHidden = true
            }
            
            
            numberOfAssignmentLabel.text = "\(course.assignmentsCount ?? 0)"
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
            return "\(shortcut.split(separator: " ")[0].first!)\(shortcut.split(separator: " ")[1].first!)"
        }
        
    }
    
    

}
