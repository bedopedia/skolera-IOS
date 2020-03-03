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
    var child : Actor!
    
    /// date source for tableView
    var courseGroups = [ShortCourseGroup]()
    //MARK: - Outlets
    
    @IBOutlet var placeholderView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if courseGroups.isEmpty {
            placeholderView.isHidden = false
        } else {
            placeholderView.isHidden = true
        }
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseGroups.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Subjects".localized
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseGradeCell", for: indexPath) as! CourseGradeCell
        cell.courseGroup = courseGroups[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CourseGradeCell
        let selectGradingPeriodVC = SelectGradingPeriodViewController.instantiate(fromAppStoryboard: .Grades)
        selectGradingPeriodVC.child = child
        selectGradingPeriodVC.courseGroup = cell.courseGroup
        self.navigationController?.pushViewController(selectGradingPeriodVC, animated: true)
    }

}
