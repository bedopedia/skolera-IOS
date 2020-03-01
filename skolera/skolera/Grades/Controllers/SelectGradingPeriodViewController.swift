//
//  SelectGradingPeriodViewController.swift
//  skolera
//
//  Created by Salma Medhat on 2/11/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SelectGradingPeriodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectQuarterView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectPeriodTextField: UITextField!
    @IBOutlet weak var selectQuarterTextFiled: UITextField!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var placeholderView: UIView!
    
    var gradingPeriods: [GradingPeriod] = []
    var showQuarter: Bool = false
    var child: Actor!
    var courseGroup: ShortCourseGroup!
    var selectedPeriodPos: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        getGradingPeriods()
        tableView.delegate = self
        tableView.dataSource = self
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getGradingPeriods() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        
        getGradingPeriodApi(courseId: courseGroup.courseId!) { (isSuccess, statusCode, response, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = response as? [[String : AnyObject]] {
                    if result.count == 0 {
                        self.tableView.isHidden = true
                        self.placeholderView.isHidden = false
                    } else {
                        for gradingPeriod in result {
                            self.gradingPeriods.append(GradingPeriod.init(gradingPeriod))
                        }
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.placeholderView.isHidden = true
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showQuarter {
            return self.gradingPeriods[selectedPeriodPos].subGradingPeriodsAttributes.count
        } else {
            return self.gradingPeriods.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        if showQuarter {
            cell.textLabel?.text = self.gradingPeriods[selectedPeriodPos].subGradingPeriodsAttributes[indexPath.row].name
        } else {
            cell.textLabel?.text = self.gradingPeriods[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if showQuarter {
            openGradesScreen(gradingPeriodId: self.gradingPeriods[selectedPeriodPos].subGradingPeriodsAttributes[indexPath.row].id)
        } else {
            if gradingPeriods[indexPath.row].subGradingPeriodsAttributes.count > 0 {
                selectedPeriodPos = indexPath.row
                showQuarter = true
                tableViewTopConstraint.constant = 49
                selectQuarterView.isHidden = false
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                self.selectPeriodTextField.text = self.gradingPeriods[indexPath.row].name
            } else {
                showQuarter = false
                openGradesScreen(gradingPeriodId: self.gradingPeriods[indexPath.row].id)
            }
            
            
        }
    }
    
    func openGradesScreen(gradingPeriodId: Int) {
        let courseGradeVC = CourseGradeViewController.instantiate(fromAppStoryboard: .Grades)
        courseGradeVC.child = child
        courseGradeVC.courseGroup = courseGroup
        courseGradeVC.gradingPeriodId = gradingPeriodId
        self.navigationController?.navigationController?.pushViewController(courseGradeVC, animated: true)
        
    }
    
    @IBAction func choosePeriod() {
        showQuarter = false
        tableViewTopConstraint.constant = 0
        tableView.isHidden = false
        self.selectQuarterView.isHidden = true
        self.selectPeriodTextField.text = ""
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
}
