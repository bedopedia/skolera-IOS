//
//  QuizTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var dueMonthLabel: UILabel!
    @IBOutlet weak var quizDateView: UIView!
    @IBOutlet weak var quizClockImage: UIImageView!
    @IBOutlet weak var quizDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var leftView: UIView!
    
    let yellowColor = #colorLiteral(red: 0.5019607843, green: 0.3764705882, blue: 0.1803921569, alpha: 1)
    let greenColor = #colorLiteral(red: 0.1450980392, green: 0.6588235294, blue: 0.2784313725, alpha: 1)
    let redColor = #colorLiteral(red: 0.8509803922, green: 0.1058823529, blue: 0.0862745098, alpha: 1)
    
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
                publishDateLabel.text = "published \(newDateFormat.string(from: quizDate!))"
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
                dateFormatter.timeZone = TimeZone.init(identifier: "UTC")
                let quizDate = dateFormatter.date(from: quizStringDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "h:mm a"
                quizDateLabel.text = newDateFormat.string(from: quizDate!)
                if quiz.state.elementsEqual("running") {
                    quizDateLabel.textColor =  greenColor
                    dueDayLabel.textColor = greenColor
                    dueMonthLabel.textColor = greenColor
                    quizClockImage.image = #imageLiteral(resourceName: "ic_clock_green")
                    leftView.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.937254902, blue: 0.8039215686, alpha: 0.3)
                } else if quiz.state.elementsEqual("finished") {
                    quizDateLabel.textColor = redColor
                    quizClockImage.image = #imageLiteral(resourceName: "ic_clock_red")
                    dueDayLabel.textColor = redColor
                    dueMonthLabel.textColor = redColor
                    leftView.backgroundColor = #colorLiteral(red: 1, green: 0.8784313725, blue: 0.8745098039, alpha: 0.25)
                } else {
                    quizDateLabel.textColor = yellowColor
                    quizClockImage.image = #imageLiteral(resourceName: "ic_brown_clock")
                    dueDayLabel.textColor = yellowColor
                    dueMonthLabel.textColor = yellowColor
                    leftView.backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.8392156863, alpha: 0.3)
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
