//
//  SubmitExcuseViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class SubmitExcuseViewController: UIViewController {
    
    @IBOutlet weak var commentLabel: KMPlaceholderTextView!
    
    var didSubmit: ((String) -> ())!
    var comment = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentLabel.layer.borderWidth = 1
        commentLabel.layer.borderColor = #colorLiteral(red: 0.6460315585, green: 0.6780731678, blue: 0.7072373629, alpha: 1)
        commentLabel.layer.cornerRadius = 6
        commentLabel.text = comment
        
    }
    
    @IBAction func close() {
        //        self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true)
    }
    
    @IBAction func submit() {
        if !commentLabel.text.isEmpty {
            didSubmit(commentLabel.text)
            close()
        } else {
            debugPrint("empty comment")
            //present an alert
        }
    }
    
}
