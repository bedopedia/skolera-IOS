//
//  NotificationsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/24/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import SkeletonView

class NotificationsViewController: UIViewController,  UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var headerView: UIView!
    
    var fromChildrenList = false
    var notifications: [Notification]!
    var meta: Meta?
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if !fromChildrenList {
           backButton.isHidden = true
        } else {
            backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        }
        headerView.addShadow()
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
        let userType = getUserType()
        if userType == .student {
            tabBarItem.selectedImage = UIImage(named: "studentActiveNotificationIcon")?.withRenderingMode(
                .alwaysOriginal)
        } else if userType == .parent {
            tabBarItem.selectedImage = UIImage(named: "parentActiveNotificationIcon")?.withRenderingMode(
            .alwaysOriginal)
        } else {
            tabBarItem.selectedImage = UIImage(named: "teacherActiveNotification")?.withRenderingMode(
                .alwaysOriginal)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutSkeletonIfNeeded()
    }
  
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1 && fromChildrenList
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    @objc private func refreshData() {
        fixTableViewHeight()
        getNotifcations()
        refreshControl.endRefreshing()
    }

    func fixTableViewHeight() {
        tableView.estimatedRowHeight = 124
        tableView.rowHeight = 124
    }
    
    @IBAction func logout () {
        if let mainViewController = parent as? TabBarViewController {
            if getUserType() == UserType.teacher {
                mainViewController.logout()
            } else {
                mainViewController.openSettings()
            }
        }
    }
    
    func setNotificationsSeen() {
//        fixTableViewHeight()
//        self.tableView.showAnimatedSkeleton()
        setNotificationSeenAPI { (isSuccess, statusCode, error) in
//            self.tableView.hideSkeleton()
            debugPrint("Notification is Seen")
        }
    }
    
    /// service call to get notification given current page for pagination
    ///
    /// - Parameter page: page number
    func getNotifcations(page: Int = 1) {
        if page == 1 {
            tableView.showAnimatedSkeleton()
        }
        getNotificationsAPI(page: page) { (isSuccess, statusCode, value, error) in
            if page == 1 {
                self.tableView.hideSkeleton()
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
                self.tableView.reloadData()
                self.notifications = []
            }
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
        if notifications != nil {
            if !notifications.isEmpty {
                return notifications.count
            } else {
                return 0
            }
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        if let tempNotifications = notifications {
            if tempNotifications.count > indexPath.row {
                cell.hideSkeleton()
                let notification = notifications[indexPath.row]
                cell.notification = notification
            }
            if indexPath.row == notifications.count - 1 {
                if meta?.currentPage != meta?.totalPages {
                    getNotifcations(page: (meta?.currentPage)! + 1)
                }
            }
        }
        //Loading More
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
}
