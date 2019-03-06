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
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Math"
        // Do any additional setup after loading the view.
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
        cell.selectionStyle = .none
        return cell
    }
    
    
}
