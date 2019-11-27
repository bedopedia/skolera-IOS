//
//  NotificationsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/24/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SkeletonView

class NotificationsViewController: UIViewController, NVActivityIndicatorViewable,  UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var fromChildrenList = false
    var notifications: [Notification] = []
    /// carries data for notifications pagination
    var meta: Meta?
    private let refreshControl = UIRefreshControl()
    var networkSucceeded = false
    
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
        headerView.addShadow()
//        getNotifcations()
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }
  
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1 && fromChildrenList
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        getNotifcations()
        refreshControl.endRefreshing()
    }

    @IBAction func logout () {
        if let mainViewController = parent as? TeacherContainerViewController {
            mainViewController.logout()
        }
        if let mainViewController = parent as? ChildHomeViewController {
            mainViewController.openSettings()
        }
    }
    
    func setNotificationsSeen() {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        setNotificationSeenAPI { (isSuccess, statusCode, error) in
            self.stopAnimating()
            debugPrint("Notification is Seen")
        }
    }
    
    /// service call to get notification given current page for pagination
    ///
    /// - Parameter page: page number
    func getNotifcations(page: Int = 1) {
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getNotificationsAPI(page: page) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
            if isSuccess {
                if let result = value as? [String: AnyObject] {
                    let notificationResponse = NotifcationResponse.init(fromDictionary: result)
                    self.notifications.append(contentsOf: notificationResponse.notifications)
                    self.meta = notificationResponse.meta
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.notifications, imageName: "notificationsplaceholder", placeholderText: "You don't have any notifications for now".localized)
        }
    }
    
    @IBAction func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NotificationsViewController: SkeletonTableViewDataSource, UITableViewDelegate {
 
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "notificationCell"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if networkSucceeded {
            return notifications.count
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        if networkSucceeded {
            let notification = notifications[indexPath.row]
            cell.notification = notification
            //Loading More
            if indexPath.row == notifications.count - 1 {
                if meta?.currentPage != meta?.totalPages {
                    getNotifcations(page: (meta?.currentPage)! + 1)
                }
            }
        } else {
            cell.showShimmer()
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
}
