//
//  TeacherCoursesTableViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class TeacherCoursesTableViewController: UITableViewController {
    
    var courses: [TeacherCourse] = []

    
    var actor: Actor!{
        didSet {
            if actor != nil {
                getCourses()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if actor != nil {
            getCourses()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.courses.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseGroupsVC: TeacherCourseGroupViewController = TeacherCourseGroupViewController.instantiate(fromAppStoryboard: .HomeScreen)
        courseGroupsVC.course = self.courses[indexPath.row]
        self.navigationController?.pushViewController(courseGroupsVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCourseTableViewCell") as! TeacherCourseTableViewCell
        cell.course = courses[indexPath.row]
        return cell
    }
    
    func getCourses() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let headers : HTTPHeaders? = getHeaders()
        // parentId is mapping to actable Id of teacher
        let url = String(format: GET_TEACHER_COURSES(), actor.actableId)
        Alamofire.request(url, method: .get, parameters: nil, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    debugPrint(result)
                    let teacherCourses: [TeacherCourse] = result.map({ TeacherCourse($0) })
                    self.courses = teacherCourses
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
    

    

    func getText(name: String) -> String {
        let shortcut = name.replacingOccurrences(of: "&", with: "")
        if shortcut.split(separator: " ").count == 1 {
            //            return "\(shortcut.first!)"
            return String(shortcut.prefix(2))
        } else {
            return "\(shortcut.split(separator: " ")[0].first!)\(shortcut.split(separator: " ")[1].first!)"
        }
        
    }

}
