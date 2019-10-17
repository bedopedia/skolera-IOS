//
//  QuizQuestionTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionBodyLabel: UILabel!
    @IBOutlet weak var questionImageView: UIImageView!
    @IBOutlet weak var questtionNumberLabelWidth: NSLayoutConstraint!
    
    var questionType: QuestionTypes! {
        didSet {
                if self.questionType! == QuestionTypes.match {
                self.questionNumberLabel.isHidden = false
            } else {
                self.questionNumberLabel.isHidden = true
            }
        }
    }
    
    var question: Questions! {
        didSet {
            questionBodyLabel.attributedText = self.question.body?.htmlToAttributedString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
