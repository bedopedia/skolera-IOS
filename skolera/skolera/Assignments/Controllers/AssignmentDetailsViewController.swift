//
//  AssignmentDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AssignmentDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var child : Child!
    var assignment: FullAssignment!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        titleLabel.text = assignment.name
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
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

extension AssignmentDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.assignment.uploadedFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentContentTableViewCell") as! AssignmentContentTableViewCell
            if let content = self.assignment.content {
//                cell.label.attributedText = content.htmlToAttributedString
                cell.label.update(input: content)
            } else {
//                cell.label.text = "No content".localized
                cell.label.update(input: "No content".localized)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttachmentTableViewCell") as! AttachmentTableViewCell
            cell.uploadedFile = self.assignment.uploadedFiles[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if let url = URL(string: self.assignment.uploadedFiles[indexPath.row - 1].url ?? "") {
                UIApplication.shared.open(url)
            }
        }
    }
    
}
