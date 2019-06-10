//
//  AssignmentsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AssignmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var childImageView: UIImageView!
    
    var child : Child!
    var assignments = [FullAssignment]()
    
    var meta: Meta!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        getAssignments()
    }
    

    func getAssignments(page: Int = 1){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = ["page": page, "per_page" : 20]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_ASSINGMENTS(), child.id)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                //change next line into [[String : AnyObject]] if parsing Json array
                if let result = response.result.value as? [String : AnyObject]
                {
                    let assignmentsResponse = AssignmentsResponse(result)
                    self.assignments = assignmentsResponse.assignments ?? []
                    self.meta = assignmentsResponse.meta
                    self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableViewCell") as! AssignmentTableViewCell
        if indexPath.row == assignments.count - 1{
            if meta.currentPage != meta.totalPages{
                getAssignments(page: (meta.currentPage)! + 1)
            }
        }
        return cell
    }

}
