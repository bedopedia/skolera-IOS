
//
//  QuizAnswrTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import RichTextView

class QuizAnswerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var matchLeftView: UIView!
    @IBOutlet weak var matchTextField: UITextField!
    @IBOutlet weak var answerTextView: RichTextView!
    @IBOutlet weak var answerLeftImageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    
    var isAnswers = false
    var updateMatchAnswer: ((String!, String) -> ())!
    var matchString: String! {
        didSet {
            answerTextView.update(input: self.matchString)
            answerTextView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
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
    var answer: Answer! {
        didSet {
//            Might be a redundant check
            if questionType != QuestionTypes.match {
                answerTextView.backgroundColor = .white
                answerTextView.update(input: self.answer.body)
            }
            matchTextField.delegate = self
            matchTextField.font = UIFont(name: ".SFUIDisplay-Bold", size: 14)
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
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        // User finished typing (hit return): hide the keyboard.
//        debugPrint(matchTextField.text)
//        return true
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        matchLeftView.layer.borderWidth = 1
        matchLeftView.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        matchLeftView.layer.cornerRadius = 6
        matchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        debugPrint(matchTextField.text)
//        call a closure to update the matches map, match string is available from which i can get the array index
        updateMatchAnswer(textField.text, matchString)
    }

}
