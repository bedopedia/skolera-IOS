//
//  QuizSubmissionViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/30/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizSubmissionViewController: UIViewController {

    var openQuizStatus: (()->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showQuizGrade() {
        self.dismiss(animated: true, completion: nil)
        openQuizStatus()
        
    }

}
