//
//  QuizzesCoursesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class QuizzesCoursesViewController: UIViewController {
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var child : Child!
    var courses = [QuizCourse]()
    
    var meta: Meta!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        getCourses()
    }
    
    func getCourses(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_QUIZZES_COURSES(), child.id)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    debugPrint(result)
                    let quizCourses: [QuizCourse] = result.map({ QuizCourse($0) })
                    self.courses = quizCourses
                    self.tableView.reloadData()
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

extension QuizzesCoursesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCourseTableViewCell") as! QuizCourseTableViewCell
        cell.course = courses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let quizVC = QuizzesViewController.instantiate(fromAppStoryboard: .Quizzes)
        quizVC.child = self.child
        quizVC.courseName = "English"
//        assignmentsVC.courseId = courses[indexPath.row].courseId
        self.navigationController?.pushViewController(quizVC, animated: true)
    }
}
