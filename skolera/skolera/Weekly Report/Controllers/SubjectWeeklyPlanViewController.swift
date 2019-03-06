//
//  SubjectWeeklyPlanViewController.swift
//  skolera
//
//  Created by Yehia Beram on 3/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class SubjectWeeklyPlanViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dailyNote: DailyNote!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = dailyNote.title
        tableView.register(UINib(nibName: "WeeklyInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "WeeklyInfoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }

}

extension SubjectWeeklyPlanViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeeklyInfoTableViewCell", for: indexPath) as! WeeklyInfoTableViewCell
        if indexPath.row == 0 {
            cell.itemImage.image = #imageLiteral(resourceName: "knowledge1")
            cell.itemTitle.text = "Classwork"
            if !dailyNote.classWork.isEmpty {
                cell.itemText.text = dailyNote.classWork.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<P>", with: "\n").htmlToString
            } else {
                cell.itemText.text = "No classwork"
            }
            
        } else if indexPath.row == 1 {
            cell.itemImage.image = #imageLiteral(resourceName: "2")
            cell.itemTitle.text = "Homework"
            if !dailyNote.homework.isEmpty {
                cell.itemText.text = dailyNote.homework.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<P>", with: "\n").htmlToString
            } else {
                cell.itemText.text = "No Homework"
            }
            
        } else if indexPath.row == 2 {
            cell.itemImage.image = #imageLiteral(resourceName: "3")
            cell.itemTitle.text = "Activity"
            if !dailyNote.activities.isEmpty {
                cell.itemText.text = dailyNote.activities.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<P>", with: "\n").htmlToString
            } else {
                cell.itemText.text = "No Activity"
            }
            
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
