//
//  TeacherCourseTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/30/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    
    var course: TeacherCourse!{
        didSet {
            if course != nil {
                courseImageView.isHidden = false
                subjectImageLabel.clipsToBounds = false
//                courseImageView.layer.shadowColor = UIColor.appColors.green.cgColor
//                courseImageView.layer.shadowOpacity = 0.3
//                courseImageView.layer.shadowOffset = CGSize.zero
//                courseImageView.layer.shadowRadius = 10
//                courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
                subjectImageLabel.textAlignment = .center
                subjectImageLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: .clear)
                subjectImageLabel.font = UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.semibold)
                subjectImageLabel.text = getText(name: course.name)
                courseTitle.text = course.name
            }
        }
    }
    
    var courseGroup: CourseGroup!{
        didSet {
            if courseGroup != nil {
                courseImageView.isHidden = false
                subjectImageLabel.clipsToBounds = false
//                courseImageView.layer.shadowColor = UIColor.appColors.green.cgColor
//                courseImageView.layer.shadowOpacity = 0.3
//                courseImageView.layer.shadowOffset = CGSize.zero
//                courseImageView.layer.shadowRadius = 10
//                courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
                subjectImageLabel.textAlignment = .center
                subjectImageLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: UIColor.clear)
                subjectImageLabel.font = UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.semibold)
                subjectImageLabel.text = getText(name: courseGroup.name)
                courseTitle.text = courseGroup.name
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
