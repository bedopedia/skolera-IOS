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
import SwiftDate

class AnnouncementMainViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var announcements: [Announcement] = []
    var meta: Meta?
    private let refreshControl = UIRefreshControl()
    var didLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if getUserType() == UserType.parent {
            backButton.isHidden = false
            settingsButton.isHidden = true
        } else {
            backButton.isHidden =  true
            settingsButton.isHidden = false
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        refreshData()
    }
    
    @objc private func refreshData() {
        didLoad = false
        announcements = []
        fixTableViewHeight()
        tableView.reloadData()
        tableView.showAnimatedSkeleton()
        getAnnouncements()
        refreshControl.endRefreshing()
    }
    
    fileprivate func fixTableViewHeight() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
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
            self.didLoad = true
            self.tableView.hideSkeleton()
            self.tableView.rowHeight = UITableViewAutomaticDimension
            self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
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
                    self.announcements.sort { (firstAnnouncement, secondAnnoucement) -> Bool in
                        let firstDate = firstAnnouncement.endAt.toISODate(region: Region.current) ?? DateInRegion()
                        let secondDate = secondAnnoucement.endAt.toISODate(region: Region.current) ?? DateInRegion()
                        return firstDate > secondDate
                    }
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
            handleEmptyDate(tableView: self.tableView, dataSource: self.announcements, imageName: "announcmentsplaceholder", placeholderText: "You don't have any announcements for now".localized)
        }
    }
    
    @IBAction func logout() {
        let settingsVC = SettingsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @IBAction func back() {
        //  self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationController?.popViewController(animated: true)
    }
    
}

extension AnnouncementMainViewController: UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if didLoad {
            return announcements.count
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
        if didLoad {
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
        return 80
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "AnnouncementTableViewCell"
    }
    
}
