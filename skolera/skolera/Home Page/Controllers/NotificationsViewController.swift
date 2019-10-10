//
//  NotificationsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/24/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    
    var fromChildrenList = false
    
    var notifications = [Notification]()
    
    
    /// carries data for notifications pagination
    var meta: Meta?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        if !fromChildrenList {
           backButton.isHidden = true
        } else {
            backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        }
        getNotifcations()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }
    
    @IBAction func logout () {
        if let mainViewController = parent as? TeacherContainerViewController {
            mainViewController.logout()
        }
        if let mainViewController = parent as? ChildHomeViewController {
            mainViewController.openSettings()
        }
    }
    
    func setNotificationsSeen(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        setNotificationSeenAPI { (isSuccess, statusCode, error) in
            SVProgressHUD.dismiss()
            debugPrint("Notification is Seen")
        }
    }
    
    /// service call to get notification given current page for pagination
    ///
    /// - Parameter page: page number
    func getNotifcations(page: Int = 1) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getNotificationsAPI(page: page) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [String: AnyObject] {
                    let notificationResponse = NotifcationResponse.init(fromDictionary: result)
                    self.notifications.append(contentsOf: notificationResponse.notifications)
                    self.meta = notificationResponse.meta
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }


}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        let notification = notifications[indexPath.row]
        cell.notification = notification
        //Loading More
        if indexPath.row == notifications.count - 1
        {
            if meta?.currentPage != meta?.totalPages
            {
                getNotifcations(page: (meta?.currentPage)! + 1)
            }
        }
        return cell
    }
    
    
}
