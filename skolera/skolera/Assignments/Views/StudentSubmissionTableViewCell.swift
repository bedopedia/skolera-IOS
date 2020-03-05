//
//  StudentSubmissionTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class StudentSubmissionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    var isQuiz = false
    
    var studentSubmission: AssignmentStudentSubmission! {
        didSet {
            if studentSubmission != nil {
                subjectImageLabel.text = getText(name: studentSubmission.studentName)
                itemNameLabel.text = studentSubmission.studentName
                if let graded = studentSubmission.graded, graded {
                    if !isQuiz {
                        gradeLabel.text = "\(studentSubmission.grade ?? 0)"
                    } else {
                        gradeLabel.text = "\(studentSubmission.score ?? 0)"
                    }
                    gradeLabel.textColor = #colorLiteral(red: 0.333293438, green: 0.3333562911, blue: 0.3332894742, alpha: 1)
                    if let feedback = studentSubmission.feedback, let content = feedback.content, !content.isEmpty {
                        feedbackLabel.text = content
                        feedbackLabel.textColor = #colorLiteral(red: 0.333293438, green: 0.3333562911, blue: 0.3332894742, alpha: 1)
                    } else {
                        feedbackLabel.text = "Not feedback".localized
                        feedbackLabel.textColor = #colorLiteral(red: 0.741094768, green: 0.7412235737, blue: 0.7410866618, alpha: 1)
                    }
                } else {
                    gradeLabel.text = "Not set yet".localized
                    gradeLabel.textColor = #colorLiteral(red: 0.741094768, green: 0.7412235737, blue: 0.7410866618, alpha: 1)
                    feedbackLabel.text = "Not feedback".localized
                    feedbackLabel.textColor = #colorLiteral(red: 0.741094768, green: 0.7412235737, blue: 0.7410866618, alpha: 1)
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        courseImageView.layer.cornerRadius = courseImageView.frame.height / 2
    }

    override func prepareForReuse() {
        courseImageView.layer.shadowColor = UIColor.clear.cgColor
        courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func openLink() {
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
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
