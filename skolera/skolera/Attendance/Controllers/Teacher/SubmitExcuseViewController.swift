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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
