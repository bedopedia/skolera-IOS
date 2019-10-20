
//
//  QuizAnswrTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizAnswerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var matchLeftView: UIView!
    @IBOutlet weak var matchTextField: UITextField!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var answerLeftImageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    var isAnswers = false
    var matchString: String! {
        didSet {
            answerTextLabel.attributedText = self.matchString.htmlToAttributedString
        }
    }
    var questionType: QuestionTypes! {
        didSet {
            self.hideMatchView()
            self.cellView.backgroundColor = .white
            switch self.questionType! {
            case QuestionTypes.match:
                self.showMatchView()
            case QuestionTypes.multipleChoice:
                self.answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
            case QuestionTypes.multipleSelect:
                self.answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
            case QuestionTypes.reorder:
                self.answerLeftImageView.image = #imageLiteral(resourceName: "quizReorder")
            case QuestionTypes.trueOrFalse:
                self.answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
            }
        }
    }
    var answer: Answers! {
        didSet {
            if questionType == QuestionTypes.match {
                debugPrint("match cell")
//                answerTextLabel.attributedText
            } else {
                answerTextLabel.attributedText = self.answer.body.htmlToAttributedString
            }
            matchTextField.delegate = self
            matchTextField.font = UIFont(name: ".SFUIDisplay-Bold", size: 16)
            if isAnswers {
                matchTextField.attributedText = self.answer.match.htmlToAttributedString ?? "".htmlToAttributedString
            }
        }
    }
    
    func setSelectedImage() {
        if questionType == QuestionTypes.multipleChoice || questionType == QuestionTypes.multipleSelect || questionType == QuestionTypes.trueOrFalse {
            answerLeftImageView.image = #imageLiteral(resourceName: "selectedSlot")
        }
    }
    
    func resetLeftImage() {
        answerLeftImageView.image = #imageLiteral(resourceName: "unselectedSlot")
    }
    
    func hideMatchView() {
        matchLeftView.isHidden = true
        matchTextField.isHidden = true
    }
    
    func showMatchView() {
        cellView.backgroundColor = .clear
        self.answerLeftImageView.image = nil
        matchLeftView.isHidden = false
        matchTextField.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentString: NSString = matchTextField.text as! NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
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
