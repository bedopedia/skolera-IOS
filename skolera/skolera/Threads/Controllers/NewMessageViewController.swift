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
import SkeletonView

class NewMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, SkeletonTableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectTeacherView: UIView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var selectCourseTextField: UITextField!
    @IBOutlet weak var selectTeacherTextField: UITextField!
    @IBOutlet weak var resultTableViewTopConstraint: NSLayoutConstraint!
    
    var subjects: [Subject] = []
    var showTeachers: Bool = false
    var child: Actor!
    var selectedCoursePos: Int = -1
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        fixTableViewHeight()
        resultTableView.showAnimatedSkeleton()
        resultTableView.reloadData()
        getSubjects()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fixTableViewHeight() {
          resultTableView.estimatedRowHeight = 70
          resultTableView.rowHeight = 70
      }
    
    func getSubjects() {
        let parameters : Parameters = ["source" : "home"]
        getSubjectsApi(parameters: parameters, child: child) { (isSuccess, statusCode, response, error) in
            self.didLoad = true
            self.resultTableView.hideSkeleton()
            if isSuccess {
                if let result = response as? [[String : AnyObject]] {
                    for subject in result
                    {
                        debugPrint("\(subject)\n")
                        self.subjects.append(Subject.init(fromDictionary: subject))
                    }
                    self.resultTableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if didLoad {
            if showTeachers {
                return self.subjects[selectedCoursePos].teachers.count
            } else {
                return self.subjects.count
            }
        } else {
            return 6
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell") as! SelectionTableViewCell
        cell.selectionStyle = .none
        if didLoad {
            cell.hideSkeleton()
            cell.isUserInteractionEnabled = true
            if showTeachers {
                cell.titleLabel.text = "\(self.subjects[selectedCoursePos].teachers[indexPath.row].firstname ?? "") \(self.subjects[selectedCoursePos].teachers[indexPath.row].lastname ?? "")"
                cell.subTitleLable.text = self.subjects[selectedCoursePos].course.name
            } else {
                cell.titleLabel.text = self.subjects[indexPath.row].course.name
                cell.subTitleLable.text = self.subjects[indexPath.row].teachers.count == 1 ? "\(self.subjects[indexPath.row].teachers.count) teacher" : "\(self.subjects[indexPath.row].teachers.count) teachers"
            }
        } else {
            cell.isUserInteractionEnabled = false
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
            if self.subjects[indexPath.row].teachers.count > 0 {
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
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "SelectionTableViewCell"
    }
    
    @IBAction func showCourses(){
        showTeachers = false
        resultTableViewTopConstraint.constant = 0
        self.selectTeacherView.isHidden = true
        self.selectCourseTextField.text = ""
        self.resultTableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}
