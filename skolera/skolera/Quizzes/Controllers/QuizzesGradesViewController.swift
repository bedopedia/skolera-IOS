//
//  QuizzesGradesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 8/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizzesGradesViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quizName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.text = quizName
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension QuizzesGradesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentSubmissionTableViewCell", for: indexPath) as! StudentSubmissionTableViewCell
        if indexPath.row % 2 == 0 {
            cell.feedbackLabel.text = "asdfasdfasdfjkasdhfkasvdfkhasvdkfhasvdkfhavskdhfvakshfvahksdvfhkasdvfhkasvfkas"
        } else {
            cell.feedbackLabel.text = "Not feedback"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedbackDialog = FeedbackDialogViewController.instantiate(fromAppStoryboard: .Assignments)
        self.present(feedbackDialog, animated: true, completion: nil)
    }

}
