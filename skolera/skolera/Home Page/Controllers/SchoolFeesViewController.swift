//
//  SchoolFeesViewController.swift
//  skolera
//
//  Created by Yehia Beram on 13/01/2021.
//  Copyright © 2021 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SchoolFeesViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var schoolFees = [SchoolFees]()
    var meta: Meta?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        getSchoolFees()
    }
    

    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showPlaceHolder() {
        showAlert(viewController: self, title: "SCHOOL FEES".localized, message: "There is no school fees".localized, completion: {action in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func getSchoolFees(page: Int = 1) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getSchoolFeesAPI(page: page) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String: AnyObject] {
                    let schoolFeesResponse = SchoolFeesResponse(result)
                    self.schoolFees.append(contentsOf: schoolFeesResponse.schoolFees ?? [])
                    self.meta = schoolFeesResponse.meta
                    self.tableView.reloadData()
                    if self.schoolFees.isEmpty {
                        self.tableView.isHidden = true
                        self.showPlaceHolder()
                    }
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }

}

extension SchoolFeesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolFees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolFeesTableViewCell") as! SchoolFeesTableViewCell
        let schoolFee = schoolFees[indexPath.row]
        cell.schoolFee = schoolFee
        //Loading More
        if indexPath.row == schoolFees.count - 1
        {
            if meta?.currentPage != meta?.totalPages
            {
                getSchoolFees(page: (meta?.currentPage)! + 1)
            }
        }
        return cell
    }
    
    
}
