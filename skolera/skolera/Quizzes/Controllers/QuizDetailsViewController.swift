//
//  QuizDetailsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 8/25/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizDetailsViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension QuizDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("table view height:", self.tableView.estimatedRowHeight)
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell") as! QuizDetailsTableViewCell
//        cell.behaviorNote = currentDataSource[indexPath.row]
//        if indexPath.row == currentDataSource.count - 1{
//            if meta.currentPage != meta.totalPages{
//                getBehaviorNotes(page: (meta.currentPage)! + 1)
//            }
//        }
        return cell
    }
   
    
    
    
    
}



