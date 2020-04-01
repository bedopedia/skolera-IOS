//
//  QuizDetailsViewControllerCellTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 8/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizDetailsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var quizDescriptionLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var bloomsLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var subtopicLabel: UILabel!
    @IBOutlet weak var objectivesLabel: UILabel!
    @IBOutlet weak var lessonLabel: UILabel!
    @IBOutlet weak var courseGroupsLabel: UILabel!
    @IBOutlet var descriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var detailedQuiz: DetailedQuiz! {
        didSet {
            if let details = self.detailedQuiz.description, !details.isEmpty {
                quizDescriptionLabel.isHidden = false
                quizDescriptionLabel.text = self.detailedQuiz.description
                descriptionLabelHeightConstraint.constant = 20
                bottomConstraint.constant = 8
            } else {
                quizDescriptionLabel.isHidden = true
                descriptionLabelHeightConstraint.constant = 0
                bottomConstraint.constant = 0
            }
            startDateLabel.text = self.formatDate(date: self.detailedQuiz.startDate!)
            endDateLabel.text = self.formatDate(date: self.detailedQuiz.endDate!)
            durationLabel.text = "\(self.detailedQuiz.duration!) " + "Minutes".localized
            totalScoreLabel.text = "\(self.detailedQuiz.totalScore!)"
            topicLabel.text = self.detailedQuiz.unit?.name ?? ""
            subtopicLabel.text = self.detailedQuiz.chapter?.name ?? ""
            lessonLabel.text = self.detailedQuiz.lesson?.name ?? ""
            bloomsLabel.text = self.detailedQuiz.blooms.joined(separator: ", ")
            courseGroupsLabel.text = getCourseGroupsString()
            let quizObjectives = getObjectivesString()
            if !quizObjectives.isEmpty {
                objectivesLabel.text = quizObjectives
            }
        }
    }
    
    //could be a generic funciton to handle the objectives param
    func getCourseGroupsString() -> String {
        if let courseGroups = self.detailedQuiz.courseGroups {
            let string: [String] = courseGroups.map { (course) -> String in
                return course.name ?? ""
            }
            return string.joined(separator: ", ")
        }
        return ""
    }
    
    func getObjectivesString() -> String {
        if let objectives = self.detailedQuiz.objectives {
            let string: [String] = objectives.map { (objective) -> String in
                return objective.name ?? ""
            }
            return string.joined(separator: ", ")
        }
        return ""
    }
    
    func formatDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
        dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
        let quizDate = dateFormatter.date(from: date)
        let newDateFormat = DateFormatter()
        newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
//        quizDateLabel.text = newDateFormat.string(from: quizDate!)
        return newDateFormat.string(from: quizDate!)
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
