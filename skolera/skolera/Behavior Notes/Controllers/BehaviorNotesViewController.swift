//
//  BehaviorNotesViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class BehaviorNotesViewController: UIViewController{
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
    //MARK: - Outlets
    
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusSegmentControl: UISegmentedControl!
    
    //MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if isParent() {
            statusSegmentControl.tintColor = #colorLiteral(red: 0.01857026853, green: 0.7537801862, blue: 0.7850604653, alpha: 1)
        } else {
            statusSegmentControl.tintColor = #colorLiteral(red: 0.9931195378, green: 0.5081273317, blue: 0.4078431373, alpha: 1)
        }
        
        getBehaviorNotes()
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
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = ["student_id" : child.actableId,"user_type" : "Parents", "page": page, "per_page" : 20]
        let headers : HTTPHeaders? = getHeaders()
        let url = GET_BEHAVIOR_NOTES()
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let result = response.result.value as? [String : AnyObject]
                {
                    let behaviorNotesResponse = BehaviorNotesResponse.init(fromDictionary: result)
                    self.behaviorNotes = behaviorNotesResponse.behaviorNotes
                    self.meta = behaviorNotesResponse.meta
                    self.loadPositiveNotes()
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 ||  response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
}
