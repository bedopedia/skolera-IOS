//
//  QuizDetailsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 8/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class QuizDetailsViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quizId: Int!
    var detailedQuiz: DetailedQuiz!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        titleLabel.text = self.detailedQuiz.name ?? ""
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension QuizDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as! QuizDetailsTableViewCell
        if detailedQuiz != nil {
            cell.detailedQuiz = self.detailedQuiz
        }
        return cell
    }
    
    
}
   
    
    
    
    




