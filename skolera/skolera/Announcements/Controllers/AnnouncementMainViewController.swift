//
//  AnnouncementMainViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/23/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SkeletonView

class AnnouncementMainViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    
    var announcements: [Announcement]!
    var meta: Meta?
    private let refreshControl = UIRefreshControl()
    fileprivate func fixTableViewHeight() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        headerView.addShadow()
        fixTableViewHeight()
        self.tableView.reloadData()
        tableView.showAnimatedSkeleton()
        getAnnouncements()
        
    }
    @objc private func refreshData(_ sender: Any) {
        refreshControl.beginRefreshing()
        fixTableViewHeight()
        tableView.showAnimatedSkeleton()
        getAnnouncements()
        refreshControl.endRefreshing()
    }
    //    MARK: - Swipe
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    func getAnnouncements(page: Int = 1) {
        getAnnouncementsApi(page: page) { (isSuccess, statusCode, value, error) in
            if page == 1 {
                self.tableView.hideSkeleton()
                self.tableView.rowHeight = UITableViewAutomaticDimension
                self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
            }
            if self.announcements == nil {
                self.announcements = []
            }
            if isSuccess {
                if let result = value as? [String: AnyObject] {
                    if let metaResponse = result["meta"] as? [String: AnyObject] {
                        self.meta = Meta(fromDictionary: metaResponse)
                    }
                    if let announcementsResponse =  result["announcements"] as? [[String: AnyObject]] {
                        for item in announcementsResponse {
                            let announcement = Announcement(fromDictionary: item)
                            self.announcements.append(announcement)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.announcements ?? [], imageName: "announcmentsplaceholder", placeholderText: "You don't have any announcements for now".localized)
        }
    }
    
    @IBAction func logout() {
        let parentController = parent?.parent
        if let mainViewController = parentController as? TeacherContainerViewController {
            mainViewController.logout()
        }
        if let mainViewController = parentController as? ChildHomeViewController {
            mainViewController.openSettings()
        }
    }
    
}

extension AnnouncementMainViewController: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if announcements != nil {
            return announcements.count
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
        if announcements != nil {
            cell.hideSkeleton()
            let announcement = announcements[indexPath.row]
            cell.announcement = announcement
            //        Loading More
            if indexPath.row == announcements.count - 1 {
                if meta?.currentPage != meta?.totalPages {
                    getAnnouncements(page: (meta?.currentPage)! + 1)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let announcementsVc = AnnouncementViewController.instantiate(fromAppStoryboard: .Announcements)
        announcementsVc.announcement = announcements[indexPath.row]
        self.navigationController?.pushViewController(announcementsVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AnnouncementTableViewCell"
    }
    
}
