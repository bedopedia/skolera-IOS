//
//  NewMessageViewController.swift
//  skolera
//
//  Created by Yehia Beram on 5/20/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Chatto
import ChattoAdditions

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var selectTeacherView: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var selectCourseTextField: UITextField!
    @IBOutlet weak var selectTeacherTextField: UITextField!
    @IBOutlet weak var resultTableViewTopConstraint: NSLayoutConstraint!
    
    var subjects: [Subject] = []
    var showTeachers: Bool = false
    var child:Child!
    var selectedCoursePos: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getSubjects()
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getSubjects()
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = ["source" : "home"]
        let headers : HTTPHeaders? = getHeaders()
        debugPrint(userId())
        let url = String(format: GET_THREADS_COURSE_GROUPS(),child.actableId)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    
                    for subject in result
                    {
                        debugPrint("\(subject)\n")
                        self.subjects.append(Subject.init(fromDictionary: subject))
                    }
                
                    self.resultTableView.reloadData()
                    self.resultTableView.isHidden = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        })
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showTeachers {
            return self.subjects[selectedCoursePos].teachers.count
        } else {
            return self.subjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        if showTeachers {
            cell.textLabel?.text = "\(self.subjects[selectedCoursePos].teachers[indexPath.row].firstname ?? "") \(self.subjects[selectedCoursePos].teachers[indexPath.row].lastname ?? "")"
            cell.detailTextLabel?.text = self.subjects[selectedCoursePos].course.name
        } else {
            cell.textLabel?.text = self.subjects[indexPath.row].course.name
            cell.detailTextLabel?.text = self.subjects[indexPath.row].teachers.count == 1 ? "\(self.subjects[indexPath.row].teachers.count) teacher" : "\(self.subjects[indexPath.row].teachers.count) teachers"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showTeachers {
            let chatVC = ChatViewController.instantiate(fromAppStoryboard: .Threads)
            let dataSource = DemoChatDataSource(messages: [], pageSize: 50)
            chatVC.dataSource = dataSource
            chatVC.chatName = "New Message".localized
            chatVC.courseId = self.subjects[selectedCoursePos].courseId
            chatVC.teacherId = self.subjects[selectedCoursePos].teachers[indexPath.row].actableId
            chatVC.newThread = true
            self.navigationController?.pushViewController(chatVC, animated: true)
        } else {
            selectedCoursePos = indexPath.row
            showTeachers = true
            resultTableViewTopConstraint.constant = 49
            selectTeacherView.isHidden = false
            self.resultTableView.reloadData()
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            self.selectCourseTextField.text = self.subjects[indexPath.row].course.name
        }
    }
    
    @IBAction func showCourses(){
        showTeachers = false
        resultTableViewTopConstraint.constant = 0
        self.resultTableView.isHidden = false
        self.selectTeacherView.isHidden = true
        self.resultTableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
