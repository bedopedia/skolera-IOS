//
//  AssignmentCoursesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 6/12/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AssignmentCoursesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var child : Child!
    var courses = [AssignmentCourse]()
    
    var meta: Meta!

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        getCourses()
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getCourses() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getAssignmentCoursesApi(childId: child.id) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    debugPrint(result)
                    let assignmentCourses: [AssignmentCourse] = result.map({ AssignmentCourse($0) })
                    self.courses = assignmentCourses
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCourseTableViewCell") as! AssignmentCourseTableViewCell
        cell.course = courses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignmentsVC = AssignmentsViewController.instantiate(fromAppStoryboard: .Assignments)
        assignmentsVC.child = self.child
        assignmentsVC.courseName = courses[indexPath.row].courseName
        assignmentsVC.courseId = courses[indexPath.row].courseId
        self.navigationController?.pushViewController(assignmentsVC, animated: true)
    }

}
