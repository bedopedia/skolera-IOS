//
//  QuizTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var dueMonthLabel: UILabel!
    @IBOutlet weak var quizDateView: UIView!
    @IBOutlet weak var quizClockImage: UIImageView!
    @IBOutlet weak var quizDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var quiz: FullQuiz! {
        didSet {
            titleLabel.text = quiz.name
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
            let quizDate = dateFormatter.date(from: quiz.startDate)
            let endDate = dateFormatter.date(from: quiz.endDate)
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "dd MMM YYYY"
            if Language.language == .arabic {
                publishDateLabel.text = "نشر " + newDateFormat.string(from: quizDate!)
            } else {
                publishDateLabel.text = "publish \(newDateFormat.string(from: quizDate!))"
            }
            newDateFormat.dateFormat = "dd"
            dueDayLabel.text = newDateFormat.string(from: endDate!)
            newDateFormat.dateFormat = "MMM"
            dueMonthLabel.text = newDateFormat.string(from: endDate!)
            
            if let quizStringDate = quiz.endDate {
                quizDateView.isHidden = false
                quizDateLabel.isHidden = false
                quizClockImage.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let quizDate = dateFormatter.date(from: quizStringDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
                quizDateLabel.text = newDateFormat.string(from: quizDate!)
                if quiz.state.elementsEqual("running") {
                    quizDateView.backgroundColor = #colorLiteral(red: 0.8247086406, green: 0.9359105229, blue: 0.8034248352, alpha: 1)
                    quizDateLabel.textColor = #colorLiteral(red: 0.1179271713, green: 0.2293994129, blue: 0.09987530857, alpha: 1)
                    quizClockImage.image = #imageLiteral(resourceName: "greenHour")
                } else {
                    quizDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
                    quizDateLabel.textColor = #colorLiteral(red: 0.4231846929, green: 0.243329376, blue: 0.1568627451, alpha: 1)
                    quizClockImage.image = #imageLiteral(resourceName: "1")
                }
            } else {
                quizDateView.isHidden = true
                quizDateLabel.isHidden = true
                quizClockImage.isHidden = true
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
