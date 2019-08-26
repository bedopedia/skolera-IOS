//
//  QuizDetailsViewControllerCellTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 8/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizDetailsViewControllerTableViewCell: UITableViewCell {
    
//
//    @IBOutlet weak var courseImageView: UIImageView!
//    @IBOutlet weak var subjectImageLabel: UILabel!
//    @IBOutlet weak var courseTitle: UILabel!
//
//    var course: TeacherCourse!{
//        didSet {
//            if course != nil {
//                courseImageView.isHidden = false
//                subjectImageLabel.clipsToBounds = false
//                courseImageView.layer.shadowColor = UIColor.appColors.green.cgColor
//                courseImageView.layer.shadowOpacity = 0.3
//                courseImageView.layer.shadowOffset = CGSize.zero
//                courseImageView.layer.shadowRadius = 10
//                courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
//                subjectImageLabel.textAlignment = .center
//                subjectImageLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: UIColor.appColors.green)
//                subjectImageLabel.font = UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.semibold)
//                subjectImageLabel.text = getText(name: course.name)
//                courseTitle.text = course.name
//            }
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
