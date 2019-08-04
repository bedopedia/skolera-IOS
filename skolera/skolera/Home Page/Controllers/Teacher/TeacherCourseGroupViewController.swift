//
//  CourseGroupViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCourseGroupViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var courseGroupTableView: UITableView!
    
    var course: TeacherCourse!

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        titleLabel.text = course.name 
        courseGroupTableView.delegate = self
        courseGroupTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension TeacherCourseGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.courseGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeacherCourseTableViewCell") as! TeacherCourseTableViewCell
        cell.courseGroup = course.courseGroups[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseGroupsVC: TeacherCourseDetailsViewController = TeacherCourseDetailsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        courseGroupsVC.courseGroup = course.courseGroups[indexPath.row]
        courseGroupsVC.course = course
        self.navigationController?.pushViewController(courseGroupsVC, animated: true)
    }
  
    
}


