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
        setNotificationsSeen()
    }

    // MARK: - Table view data source

    
    func setNotificationsSeen(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: SET_SEEN_NOTIFICATIONS(), userId())
        Alamofire.request(url, method: .post, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                debugPrint(response)
//                if let result = response.result.value as? [String: AnyObject]
//                {
//                    debugPrint(result)
//                    let notificationResponse = NotifcationResponse.init(fromDictionary: result)
//                    self.notifications.append(contentsOf: notificationResponse.notifications)
//                    self.meta = notificationResponse.meta
//                    self.tableView.reloadData()
//                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
    }
    
    /// service call to get notification given current page for pagination
    ///
    /// - Parameter page: page number
    func getNotifcations(page: Int = 1)
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_NOTIFCATIONS(),userId(),page)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [String: AnyObject]
                {
                    let notificationResponse = NotifcationResponse.init(fromDictionary: result)
                    self.notifications.append(contentsOf: notificationResponse.notifications)
                    self.meta = notificationResponse.meta
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: nil)
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    
                }
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
