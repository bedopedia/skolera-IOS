
//
//  QuizAnswrTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var matchLeftView: UIView!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var answerLeftImageView: UIImageView!
    @IBOutlet weak var answerRightImageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    var questionType: QuestionTypes! {
        
        didSet {
            self.hideMatchView()
            switch self.questionType! {
            case QuestionTypes.match:
                debugPrint("match")
                self.showMatchView()
            case QuestionTypes.multipleChoice:
                debugPrint("multipleChoice")
                self.answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
            case QuestionTypes.multipleSelect:
                debugPrint("multipleSelect")
                //set asset
                self.answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
            case QuestionTypes.reorder:
                debugPrint("reorder")
                self.answerLeftImageView.image = #imageLiteral(resourceName: "quizReorder")
            case QuestionTypes.trueOrFalse:
                debugPrint("trueOrFalse")
                self.answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
            }
        }
    }
    var answer: Answers! {
        didSet {
            answerTextLabel.text = self.answer.body
        }
    }
    
    func hideMatchView() {
        matchLeftView.isHidden = true
        matchLabel.isHidden = true
    }
    func showMatchView() {
        cellView.backgroundColor = .clear
        self.answerLeftImageView.image = nil
        matchLeftView.isHidden = false
        matchLabel.isHidden = false
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        matchLeftView.layer.borderWidth = 1
        matchLeftView.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        matchLeftView.layer.cornerRadius = 6
//        matchLeftView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
