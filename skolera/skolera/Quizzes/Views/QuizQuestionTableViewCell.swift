//
//  QuizQuestionTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import RichTextView

class QuizQuestionTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var questionBodyLabel: RichTextView!
    @IBOutlet weak var questtionNumberLabelWidth: NSLayoutConstraint!
    
    var question: Questions! {
        didSet{
            self.questionNumberLabel.isHidden = true
//            questionBodyLabel.update(input: self.question.body)
//            questionBodyLabel.attributedText = self.question.body?.htmlToAttributedString
        }
    }
    var option: Options! {
        didSet{
            self.questionNumberLabel.isHidden = false
//            questionBodyLabel.update(input: self.option.body)
//            questionBodyLabel.attributedText = self.option.body?.htmlToAttributedString
            
        }
    }
    var questionType: QuestionTypes!
    var matchIndex: Int! {
        didSet {
            questionNumberLabel.text = "\(self.matchIndex ?? 0)"
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
