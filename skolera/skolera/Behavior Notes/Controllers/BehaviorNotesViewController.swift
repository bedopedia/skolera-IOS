//
//  BehaviorNotesViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class BehaviorNotesViewController: UIViewController, NVActivityIndicatorViewable{
    //TODO:- Fix Cell Height
    //MARK: - Variables
    var child : Child!
    var behaviorNotes = [BehaviorNote]()
    var currentDataSource = [BehaviorNote](){
        didSet {
            self.tableView.reloadData()
        }
    }
    var meta: BehaviorNotesResponseMeta!
    private let refreshControl = UIRefreshControl()

    //MARK: - Outlets
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
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
        getBehaviorNotes()
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

    }
    @objc private func refreshData(_ sender: Any) {
            // Fetch Weather Data
            refreshControl.beginRefreshing()
            getBehaviorNotes()
            refreshControl.endRefreshing()
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

extension BehaviorNotesViewController: UITableViewDelegate, UITableViewDataSource{
    
    var positiveNotes: [BehaviorNote] {
        let result = behaviorNotes.filter { (behaviorNote) -> Bool in
            return behaviorNote.type == "Good"
        }
        return result
    }
    var negativeNotes: [BehaviorNote] {
        let result = behaviorNotes.filter { (behaviorNote) -> Bool in
            return behaviorNote.type == "Bad"
        }
        return result
    }
    var otherNotes: [BehaviorNote] {
        let result = behaviorNotes.filter { (behaviorNote) -> Bool in
            return behaviorNote.type == "Other"
        }
        return result
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "behaviorNoteCell") as! BehaviorNoteTableViewCell
        cell.behaviorNote = currentDataSource[indexPath.row]
        if indexPath.row == currentDataSource.count - 1{
            if meta.currentPage != meta.totalPages{
                getBehaviorNotes(page: (meta.currentPage)! + 1)
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
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters : Parameters = ["student_id" : child.actableId,"user_type" : "Parents", "page": page, "per_page" : 20]
        getBehaviorNotesAPI(parameters: parameters) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String : AnyObject] {
                    let behaviorNotesResponse = BehaviorNotesResponse.init(fromDictionary: result)
                    self.behaviorNotes = behaviorNotesResponse.behaviorNotes
                    self.meta = behaviorNotesResponse.meta
                    self.loadPositiveNotes()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
}
