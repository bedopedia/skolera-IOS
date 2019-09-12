//
//  NotifcationsTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/31/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class NotificationsTableViewController: UITableViewController {
    // MARK: - variables
    
    /// data source for tableview
    var notifications = [Notification]()
    
    /// carries data for notifications pagination
    var meta: Meta?
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        getNotifcations()
//        setNotificationsSeen()
    }

    // MARK: - Table view data source

    
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }

    /// fills notification cell data, checks if reached last notification to ask for next notification page
    ///
    /// - Parameters:
    ///   - tableView: screen table view
    ///   - indexPath: cell section and row
    /// - Returns: NotificationTableViewCell filled with its contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    //MARK: - Actions

    /// dismisses current screen modally
    ///
    /// - Parameter sender: close button
    @IBAction func close(_ sender: UIBarButtonItem) {
        if(SVProgressHUD.isVisible())
        {
            SVProgressHUD.dismiss()
        }
        dismiss(animated: true, completion: nil)
    }
    
    

}
