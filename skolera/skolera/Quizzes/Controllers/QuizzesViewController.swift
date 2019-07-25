//
//  QuizzesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class QuizzesViewController: UIViewController {
    
    var child : Child!
    var courseName: String = ""
    var courseId: Int = 0
    var quizzes: [FullQuiz] = []
    var filteredQuizzes: [FullQuiz] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = courseName
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        
        if isParent() {
            statusSegmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
        } else {
            statusSegmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
        }
        
        getQuizzes()
    }
    
    @IBAction func changeDataSource(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setOpenedQuizzes()
        case 1:
            setClosedQuizzes()
        default:
            setOpenedQuizzes()
        }
    }
    
    private func setOpenedQuizzes() {
        filteredQuizzes = quizzes.filter({ $0.state.elementsEqual("running") })
        self.tableView.reloadData()
    }
    
    private func setClosedQuizzes() {
        filteredQuizzes = quizzes.filter({ !$0.state.elementsEqual("running") })
        self.tableView.reloadData()
    }
    
    func getQuizzes(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let url = String(format: GET_QUIZZES(), child.id, courseId)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let result = response.result.value as? [String : AnyObject]
                {
                    let quizResponse = QuizzesResponse(result)
                    self.quizzes = quizResponse.quizzes
                    self.setOpenedQuizzes()
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 ||  response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
}

extension QuizzesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQuizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableViewCell") as! QuizTableViewCell
        cell.nameLabel.text = courseName
        cell.quiz = self.filteredQuizzes[indexPath.row]
//        cell.assignment = filteredAssignments[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizVC = QuizStatusViewController.instantiate(fromAppStoryboard: .Quizzes)
        quizVC.child = self.child
        quizVC.courseName = courseName
        quizVC.quiz = filteredQuizzes[indexPath.row]
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
}
