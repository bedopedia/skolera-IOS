//
//  AnnouncementMainViewController.swift
//  skolera
//
//  Created by Rana Hossam on 9/23/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD


class AnnouncementMainViewController: UIViewController {

    var announcements = [Announcement]()
    var meta: Meta?
    @IBOutlet weak var tableView: UITableView!
    
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
    }

    
    func getAnnouncements(page: Int = 1) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getAnnouncementsApi(page: page) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
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
        return announcements.count
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