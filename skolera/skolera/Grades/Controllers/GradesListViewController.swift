//
//  GradesTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/4/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class GradesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //TODO:- REMAINING SCREEN FOR GRADES DETAILS
    //MARK: - Variables
    var child : Child!
    /// date source for tableView
    var grades = [PostCourse]()
    //MARK: - Outlets
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.addShadow()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 85
        tableView.delegate = self
        tableView.dataSource = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        handleEmptyDate(tableView: self.tableView, dataSource: self.grades, imageName: "gradesplaceholder", placeholderText: "You don't have any courses for now".localized)
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grades.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseGradeCell", for: indexPath) as! CourseGradeCell
        cell.grade = grades[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CourseGradeCell
        let cgVC = CourseGradeViewController.instantiate(fromAppStoryboard: .Grades)
        cgVC.child = child
        cgVC.grade = cell.grade
        self.navigationController?.pushViewController(cgVC, animated: true)
    }

}
