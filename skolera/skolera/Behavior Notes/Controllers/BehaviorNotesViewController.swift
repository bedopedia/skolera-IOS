//
//  BehaviorNotesViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import SkeletonView
class BehaviorNotesViewController: UIViewController {
    //TODO:- Fix Cell Height
    //MARK: - Variables
    var child : Child!
    var behaviorNotes: [BehaviorNote] = []
    var currentDataSource: [BehaviorNote]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    var meta: BehaviorNotesResponseMeta!
    private let refreshControl = UIRefreshControl()

    //MARK: - Outlets
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        headerView.addShadow()
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        statusSegmentControl.setTitleTextAttributes([.foregroundColor: getMainColor(), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        statusSegmentControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .selected)
        if isParent() {
            if #available(iOS 13.0, *) {
                statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            } else {
                statusSegmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
            }
        } else {
            if #available(iOS 13.0, *) {
                statusSegmentControl.selectedSegmentTintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
            } else {
                statusSegmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
            }
        }
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
    }
   
    @objc private func refreshData() {
        fixTableViewHeight()
        getBehaviorNotes()
        refreshControl.endRefreshing()
    }
    
    func fixTableViewHeight() {
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = 80
    }
       
    @IBAction func changeDataSource(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadPositiveNotes()
        case 1:
            loadNegativeNotes()
        case 2:
            loadOtherNotes()
        default:
            loadPositiveNotes()
        }
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
}

extension BehaviorNotesViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    
    var positiveNotes: [BehaviorNote]! {
        let result = behaviorNotes.filter { (behaviorNote) -> Bool in
            return behaviorNote.type == "Good"
        }
        if result.isEmpty {
            return nil
        } else {
          return result
        }
    }
    var negativeNotes: [BehaviorNote]! {
        let result = behaviorNotes.filter { (behaviorNote) -> Bool in
            return behaviorNote.type == "Bad"
        }
        if result.isEmpty {
            return nil
        } else {
          return result
        }
    }
    var otherNotes: [BehaviorNote]! {
        let result = behaviorNotes.filter { (behaviorNote) -> Bool in
            return behaviorNote.type == "Other"
        }
        if result.isEmpty {
            return nil
        } else {
          return result
        }
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "behaviorNoteCell"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentDataSource != nil {
            if !currentDataSource.isEmpty {
              return currentDataSource.count
            } else {
                return 6
            }
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorNoteCell") as! BehaviorNoteTableViewCell
        if self.currentDataSource != nil {
            if self.currentDataSource.count > indexPath.row {
                cell.hideSkeleton()
                cell.behaviorNote = currentDataSource[indexPath.row]
            }
            if indexPath.row == currentDataSource.count - 1 {
                if meta.currentPage != meta.totalPages{
                    getBehaviorNotes(page: (meta.currentPage)! + 1)
                }
            }
        }
        return cell
    }
    func loadPositiveNotes(){
        currentDataSource = positiveNotes
    }
    func loadNegativeNotes(){
        currentDataSource = negativeNotes
    }
    func loadOtherNotes(){
        currentDataSource = otherNotes
    }
    
    func getBehaviorNotes(page: Int = 1){
        if page == 1 {
            self.tableView.showAnimatedSkeleton()
        }
        let parameters : Parameters = ["student_id" : child.actableId,"user_type" : "Parents", "page": page, "per_page" : 20]
        getBehaviorNotesAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            if page == 1 {
                self.tableView.hideSkeleton()
            }
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let behaviorNotesResponse = BehaviorNotesResponse.init(fromDictionary: result)
                    self.behaviorNotes = behaviorNotesResponse.behaviorNotes
                    self.meta = behaviorNotesResponse.meta
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                    self.loadPositiveNotes()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
}
