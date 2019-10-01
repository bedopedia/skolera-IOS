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
            self.questionNumberLabel.isHidden = true
//            NSLayoutConstraint.activate([questtionNumberLabelWidth])
            switch self.questionType! {
            case QuestionTypes.match:
                debugPrint("match")
                self.questionNumberLabel.isHidden = false
//                NSLayoutConstraint.deactivate([questtionNumberLabelWidth])
            case QuestionTypes.multipleChoice:
                debugPrint("multipleChoice")
            case QuestionTypes.multipleSelect:
                debugPrint("multipleSelect")
            case QuestionTypes.reorder:
                debugPrint("reorder")
            case QuestionTypes.trueOrFalse:
                debugPrint("reorder")
            }
        }
    }
    
    var question: Questions! {
        didSet {
            questionBodyLabel.text = self.question.body
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
