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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    
    var child : Actor!
    var dailyNote: DailyNote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        titleLabel.text = dailyNote.title
        tableView.register(UINib(nibName: "WeeklyInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "WeeklyInfoTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
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
            cell.itemTitle.text = "Classwork".localized
            if !dailyNote.classWork.isEmpty {
                cell.itemTextView.update(input: dailyNote.classWork)
            } else {
                if Language.language == .arabic {
                    cell.itemTextView.update(input: """
                        <div align="right"><style type="text/css">ul { direction: rtl; }ol { direction: rtl; }</style>\("No classwork".localized)</div>
                        """)
                } else {
                    cell.itemTextView.update(input: "<p>\("No classwork".localized)</p>")
                }
                
            }
            
        } else if indexPath.row == 1 {
            cell.itemImage.image = #imageLiteral(resourceName: "2")
            cell.itemTitle.text = "Homework".localized
            if !dailyNote.homework.isEmpty {
                cell.itemTextView.update(input: dailyNote.homework)
            } else {
                if Language.language == .arabic {
                    cell.itemTextView.update(input: """
                        <div align="right"><style type="text/css">ul { direction: rtl; }ol { direction: rtl; }</style>\("No Homework".localized)</div>
                        """)
                } else {
                    cell.itemTextView.update(input: "<p>\("No Homework".localized)</p>")
                }
                
            }
            
        } else if indexPath.row == 2 {
            cell.itemImage.image = #imageLiteral(resourceName: "3")
            cell.itemTitle.text = "Activity".localized
            if !dailyNote.activities.isEmpty {
                cell.itemTextView.update(input: dailyNote.activities)
            } else {
                if Language.language == .arabic {
                    cell.itemTextView.update(input: """
                        <div align="right"><style type="text/css">ul { direction: rtl; }ol { direction: rtl; }</style>\("No Activity".localized)</div>
                        """)
                } else {
                    cell.itemTextView.update(input: "<p>\("No Activity".localized)</p>")
                }
            }
            
        }
        cell.selectionStyle = .none
        return cell
    }
    
    
}
