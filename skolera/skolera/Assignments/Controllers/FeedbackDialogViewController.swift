//
//  FeedbackDialogViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class FeedbackDialogViewController: UIViewController{

    @IBOutlet weak var gradeTextField: UITextField!
    @IBOutlet weak var feedbackTextView: KMPlaceholderTextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradeTextField.layer.borderWidth = 1
        gradeTextField.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
        gradeTextField.layer.cornerRadius = 6
        
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
        feedbackTextView.layer.cornerRadius = 6
        
    }

    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(){
        close()
    }

}
