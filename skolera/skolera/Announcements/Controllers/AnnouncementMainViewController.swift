//
//  AnnouncementMainViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/23/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftDate

class AnnouncementMainViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var placeHolderView: UIView!
    
    var announcements: [Announcement]! {
        didSet {
            if self.announcements.isEmpty {
                placeHolderView.isHidden = false
            } else {
                placeHolderView.isHidden = true
            }
        }
    }
    var meta: Meta?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        getAnnouncements()
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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
        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        getAnnouncementsApi(page: page) { (isSuccess, statusCode, value, error) in
            self.stopAnimating()
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

extension AnnouncementMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if announcements == nil {
            return 0
        } else {
            return announcements.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
        let announcement = announcements[indexPath.row]
        cell.announcement = announcement
        //Loading More
        if indexPath.row == announcements.count - 1
        {
            if meta?.currentPage != meta?.totalPages
            {
                getAnnouncements(page: (meta?.currentPage)! + 1)
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
        return 60
    }
    
    
}
