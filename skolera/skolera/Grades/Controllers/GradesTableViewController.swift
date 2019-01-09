//
//  GradesTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/4/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class GradesTableViewController: UITableViewController {
    //TODO:- REMAINING SCREEN FOR GRADES DETAILS
    //MARK: - Variables
    var child : Child!
    
    /// date source for tableView
    var grades = [CourseGrade]()
    //MARK: - Outlets
    
    @IBOutlet weak var childImageView: UIImageView!
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
       tableView.rowHeight = 80
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Subjects".localized
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseGradeCell", for: indexPath) as! CourseGradeCell
        
        cell.grade = grades[indexPath.row]

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CourseGradeCell
        let cgVC = CourseGradeViewController.instantiate(fromAppStoryboard: .Grades)
        cgVC.child = child
        cgVC.grade = cell.grade
        self.navigationController?.pushViewController(cgVC, animated: true)
    }

}
