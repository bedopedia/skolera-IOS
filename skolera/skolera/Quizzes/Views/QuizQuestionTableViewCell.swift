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
    @IBOutlet weak var questionBodyView: RichTextView!
    
    var question: Questions! {
        didSet{
            self.questionNumberLabel.isHidden = true
//            questionBodyView.update(input: self.question.body)
//            questionBodyView.attributedText = self.question.body?.htmlToAttributedString
        }
    }
    var option: Options! {
        didSet{
            self.questionNumberLabel.isHidden = false
//            questionBodyView.update(input: self.option.body)
//            questionBodyView.attributedText = self.option.body?.htmlToAttributedString
            
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
