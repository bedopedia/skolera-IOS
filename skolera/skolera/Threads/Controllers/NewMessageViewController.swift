//
//  NewMessageViewController.swift
//  skolera
//
//  Created by Yehia Beram on 5/20/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Chatto
import ChattoAdditions

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var backButton: UIButton!
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
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let parentVc = parent?.parent as? ChildHomeViewController {
//            parentVc.headerHeightConstraint.constant = 0
//            parentVc.headerView.isHidden = true
        }
//        self.navigationController?.isNavigationBarHidden = true
    }
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let parentVC = parent?.parent as? ChildHomeViewController {
//            parentVC.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
//            parentVC.headerView.isHidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getSubjects() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters : Parameters = ["source" : "home"]
        getSubjectsApi(parameters: parameters, child: child) { (isSuccess, statusCode, response, error) in
            self.stopAnimating()
            if isSuccess {
               if let result = response as? [[String : AnyObject]] {
                    for subject in result
                    {
                        debugPrint("\(subject)\n")
                        self.subjects.append(Subject.init(fromDictionary: subject))
                    }
                    self.resultTableView.reloadData()
                    self.resultTableView.isHidden = false
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
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
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationController?.pushViewController(chatVC, animated: true)
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
