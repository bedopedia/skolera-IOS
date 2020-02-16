//
//  CourseGradeViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 4/12/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import YLProgressBar

class CourseGradeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    //MARK: - Outlets
    @IBOutlet weak var navbarTitleLabel: UILabel!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var placeholderView: UIView!
    @IBOutlet var placeholderLabel: UILabel!
    
    
    //MARK: - Variables
    var child : Child!
    var courseGroup: ShortCourseGroup!
    var gradingPeriodId: Int!
    var gradingPeriodGrade: GradeInGradingPeriod!
    var semesterDic: [String: [AnyObject]] = [:]
    var semesterTitles: [String] = []
    var expandedCategories: [GradeCategory] = []
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child {
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        if let courseGroup = courseGroup {
            navbarTitleLabel.text = courseGroup.courseName
        }
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        let tableViewHeaderNib = UINib.init(nibName: "GradeHeaderView", bundle: Bundle.main)
        tableView.register(tableViewHeaderNib, forHeaderFooterViewReuseIdentifier: "GradeHeaderView")
        
        getStudentGradeBook()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getStudentGradeBook()
        refreshControl.endRefreshing()
    }
    
    private func getStudentGradeBook() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getStudentGradeBookApi(childId: child.actableId, courseGroup: courseGroup, gradingPeriodId: gradingPeriodId) { (isSuccess, statusCode, response, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = response as? [String : AnyObject] {
                    debugPrint("GRADESSSS: ", result)
                    self.gradingPeriodGrade = GradeInGradingPeriod.init(result)
                    self.expandCategories()
                    self.handelGrade()
                }
            } else {
                if statusCode == 403 {
                    showAlert(viewController: self, title: "Skolera", message: "Sorry, but you're not authorized to view this page".localized, completion: { action in
                        self.back()
                    })
                } else {
                    showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
                }
            }
        }
        
    }
    
    func expandCategories(){
        for category in gradingPeriodGrade.categories {
            expandedCategories.append(category)
            for subCategories in category.subCategories {
                expandedCategories.append(subCategories)
            }
        }
    }
    
    private func handelGrade() {
        self.semesterDic = [:]
        self.semesterTitles = []
        for category in self.gradingPeriodGrade.categories {
            self.semesterTitles.append(category.name)
            self.semesterDic[category.name] = []
            if category.subCategories.count > 0 {
                for subcategory in category.subCategories {
                    self.semesterDic[subcategory.name] = []
                    self.semesterTitles.append(subcategory.name)
                    if subcategory.assignments.count > 0 {
                        semesterDic[subcategory.name]?.append("Assignments".localized as AnyObject)
                        semesterDic[subcategory.name]?.append(contentsOf: subcategory.assignments)
                    }
                    if subcategory.quizzes.count > 0 {
                        semesterDic[subcategory.name]?.append("Quizzes".localized as AnyObject)
                        semesterDic[subcategory.name]?.append(contentsOf: subcategory.quizzes)
                    }
                    if subcategory.gradeItems.count > 0 {
                        semesterDic[subcategory.name]?.append("Grade Items".localized as AnyObject)
                        semesterDic[subcategory.name]?.append(contentsOf: subcategory.gradeItems)
                    }
                }
            } else {
                if category.assignments.count > 0 {
                    semesterDic[category.name]?.append("Assignments".localized as AnyObject)
                    semesterDic[category.name]?.append(contentsOf: category.assignments)
                }
                if category.quizzes.count > 0 {
                    semesterDic[category.name]?.append("Quizzes".localized as AnyObject)
                    semesterDic[category.name]?.append(contentsOf: category.quizzes)
                }
                if category.gradeItems.count > 0 {
                    semesterDic[category.name]?.append("Grade Items".localized as AnyObject)
                    semesterDic[category.name]?.append(contentsOf: category.gradeItems)
                }
            }
        }
        semesterTitles.append("Total")
        checkData()
        tableView.reloadData()
    }
    
    
    fileprivate func checkSemesterDict() {
        var isEmptyFlag = true
        let keys = semesterDic.keys
        for key in keys {
            if semesterDic[key]!.count > 0 {
                isEmptyFlag = false
                break
            }
        }
        if isEmptyFlag {
            placeholderView.isHidden = false
            tableView.isHidden = true
        } else {
            placeholderView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    func checkData() {
        placeholderLabel.text = "You don't have any grades for now".localized
        if semesterTitles.count == 0 {
            placeholderView.isHidden = false
            tableView.isHidden = true
        } else {
            checkSemesterDict()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.semesterTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let semesterData = semesterDic[semesterTitles[section]]{
            return semesterData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let gradeHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "GradeHeaderView") as! GradeHeaderView
        
        gradeHeaderView.titleLabel.text = semesterTitles[section]
        
        let gradeCategory = expandedCategories.first {
            $0.name.elementsEqual(semesterTitles[section])
        }
        if let isParent = gradeCategory?.isParent, isParent {
            gradeHeaderView.headerView.backgroundColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        } else {
            gradeHeaderView.headerView.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.8784313725, blue: 0.8784313725, alpha: 1)
        }
        if let gradeView = gradeCategory?.gradeView, let total = gradeCategory?.total {
            let mGradeView = gradeView.replacingOccurrences(of: ".0", with: "")
            if mGradeView.contains("*") || Double(mGradeView) != nil {
                gradeHeaderView.gradeLabel.text = "\(mGradeView)/\(total)"
            } else {
                gradeHeaderView.gradeLabel.text = "\(mGradeView)"
            }
            
        } else {
            gradeHeaderView.headerView.backgroundColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            let mGradeView = gradingPeriodGrade.gradeView.replacingOccurrences(of: ".0", with: "")
            if mGradeView.contains("*") || Double(mGradeView) != nil {
                gradeHeaderView.gradeLabel.text = "\(mGradeView)/\(gradingPeriodGrade.total)"
            } else {
                gradeHeaderView.gradeLabel.text = "\(mGradeView)"
            }
        }
        
        return gradeHeaderView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item:AnyObject?
        //  var isParent: Bool?
        
        if let semesterData = semesterDic[semesterTitles[indexPath.section]]{
            item = semesterData[indexPath.row]
        }
        
        if item is String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeHeaderTableViewCell", for: indexPath as IndexPath) as! GradeHeaderTableViewCell
            cell.selectionStyle = .none
            cell.titleNameLabel.text = (item as! String)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GradeDetailTableViewCell", for: indexPath as IndexPath) as! GradeDetailTableViewCell
            cell.selectionStyle = .none
            if item is StudentGrade {
                let studentGrade = item as! StudentGrade
                cell.TitleLabel.text = studentGrade.name
                cell.avgGradeLabel.text = ""
                let mGradeView = studentGrade.gradeView.replacingOccurrences(of: ".0", with: "")
                if mGradeView.contains("*") || Double(mGradeView) != nil {
                    cell.gradeLabel.text = "\(mGradeView)/\(studentGrade.total)"
                } else {
                    cell.gradeLabel.text = "\(mGradeView)"
                }
                cell.gradeWorldLabel.text = ""
                
            }
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var item:AnyObject?
        if  let semesterData = semesterDic[semesterTitles[indexPath.section]]{
            item = semesterData[indexPath.row]
        }
        
        if item is String {
            return 40
        } else {
            return 71.5
        }
    }
    
    func round2Digits(_ double: Double) -> Double {
        let multiplier = pow(10, Double(2))
        return Darwin.round(double * multiplier) / multiplier
    }
    
}
