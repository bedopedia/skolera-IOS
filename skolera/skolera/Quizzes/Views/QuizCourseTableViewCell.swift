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
    @IBOutlet weak var quizDateView: UIView!
    @IBOutlet weak var quizClockImage: UIImageView!
    @IBOutlet weak var quizDateLabel: UILabel!
    @IBOutlet weak var numberOfQuizLabel: UILabel!
    @IBOutlet var dateViewHeightConstraint: NSLayoutConstraint!
    
    var course: QuizCourse!{
        didSet{
            courseImageView.isHidden = false
            subjectImageLabel.clipsToBounds = true
            subjectImageLabel.text = getText(name: course.courseName)
            courseTitle.text = course.courseName
            if let _ = course.nextQuizDate {
                dateViewHeightConstraint.constant = 24
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
                    quizDateLabel.textColor = #colorLiteral(red: 0.1580090225, green: 0.7655162215, blue: 0.3781598806, alpha: 1)
                    quizClockImage.image = #imageLiteral(resourceName: "ic_clock_green")
                } else {
                    quizDateLabel.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                    quizClockImage.image = #imageLiteral(resourceName: "ic_clock_red")
                }
            } else {
                dateViewHeightConstraint.constant = 0
                quizDateView.isHidden = true
                quizDateLabel.isHidden = true
                quizClockImage.isHidden = true
            }
            if let count = course.runningQuizzesCount, count > 0 {
                quizName.text = course.quizName
                numberOfQuizLabel.text = "\(count)"
            } else {
                quizName.text = "No active quizzes currently".localized
                numberOfQuizLabel.text = ""
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
