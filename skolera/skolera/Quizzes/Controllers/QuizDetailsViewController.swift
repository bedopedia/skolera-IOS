//
//  QuizDetailsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 8/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class QuizDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var quizId: Int!
    var detailedQuiz: DetailedQuiz! {
        didSet {
            titleLabel.text = self.detailedQuiz.name ?? ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        getQuizDetails()
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getQuizDetails() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getQuizApi(quizId: quizId) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    self.detailedQuiz = DetailedQuiz(result)
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
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
   
    
    
    
    




