//
//  FeedbackDialogViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class FeedbackDialogViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var feedbackTextView: KMPlaceholderTextView!
    
    var didSubmitGrade: ((String, String, Int) -> ())!
    var grade: Double?
    var feedback = ""
    var feedbackId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradeTextField.layer.borderWidth = 1
        gradeTextField.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
        gradeTextField.layer.cornerRadius = 6
        gradeTextField.delegate = self
        if let myGrade = grade {
            gradeTextField.text = String(myGrade)
        }
        
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
        feedbackTextView.layer.cornerRadius = 6
        feedbackTextView.placeholder = "Write a feedback".localized
        feedbackTextView.text = feedback
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        gradeTextField.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
    }
    
    @IBAction func close(){
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submit(){
        if let grade = gradeTextField.text , !grade.isEmpty {
            close()
            didSubmitGrade(grade, feedbackTextView.text ?? "", feedbackId)
        } else {
            gradeTextField.layer.borderColor = UIColor.red.cgColor
        }
        
    }
    
    private func isNumric(string: String) -> Bool {
        return !string.isEmpty && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
}
