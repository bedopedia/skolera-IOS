//
//  QuizCourseTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizCourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var quizName: UILabel!
    @IBOutlet weak var quizDateView: UIView! {
        didSet {
            quizDateView.layer.cornerRadius = quizDateView.frame.height / 2
            quizDateView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var quizClockImage: UIImageView!
    @IBOutlet weak var quizDateLabel: UILabel!
    @IBOutlet weak var numberOfQuizLabel: UILabel!
    @IBOutlet var dateViewHeightConstraint: NSLayoutConstraint!
    
    var course: QuizCourse!{
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
            quizName.text = course.quizName == nil ? "No active quizzes currently".localized : course.quizName
            if let assignStringDate = course.nextQuizDate {
                quizDateView.isHidden = false
                quizDateLabel.isHidden = false
                quizClockImage.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let assignDate = dateFormatter.date(from: course.nextQuizDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
                quizDateLabel.text = newDateFormat.string(from: assignDate!)
                if Date() < (assignDate ?? Date()) {
                    quizDateView.backgroundColor = #colorLiteral(red: 0.8247086406, green: 0.9359105229, blue: 0.8034248352, alpha: 1)
                    quizDateLabel.textColor = #colorLiteral(red: 0.1580090225, green: 0.7655162215, blue: 0.3781598806, alpha: 1)
                    quizClockImage.image = #imageLiteral(resourceName: "ic_clock_green")
                } else {
                    quizDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
                    quizDateLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                    quizClockImage.image = #imageLiteral(resourceName: "ic_clock_red")
                }
            } else {
                quizDateView.isHidden = true
                quizDateLabel.isHidden = true
                quizClockImage.isHidden = true
            }
            numberOfQuizLabel.text = "\(course.quizzesCount ?? 0)"
            
//            if let count = course.runningAssignmentsCount, count > 0 {
//                assignmentName.text = course.assignmentName
//                numberOfAssignmentLabel.text = "\(count)"
//            } else {
//                assignmentName.text = "No active assignments currently".localized
//                numberOfAssignmentLabel.text = ""
//            }
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
    
    override func prepareForReuse() {
        courseImageView.layer.shadowColor = UIColor.clear.cgColor
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
