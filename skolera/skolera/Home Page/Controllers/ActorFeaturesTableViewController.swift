//
//  ActorFeaturesTableViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/9/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class ActorFeaturesTableViewController: UITableViewController {
    
    var actor: Parent!

    @IBOutlet weak var notificationBadge: UILabel!
    @IBOutlet weak var notificationSubTitleLabel: UILabel!
    @IBOutlet weak var messageBadge: UILabel!
    @IBOutlet weak var messagesSubTitleLabel: UILabel!
    @IBOutlet weak var announccementBadge: UILabel!
    @IBOutlet weak var announcementSubTitleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        notificationBadge.layer.masksToBounds = true
        notificationBadge.layer.cornerRadius = 10
        messageBadge.layer.masksToBounds = true
        messageBadge.layer.cornerRadius = 10
        announccementBadge.layer.masksToBounds = true
        announccementBadge.layer.cornerRadius = 10
        
        getNotifcations()
        getThreads()
        getAnnouncements()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let notificationsTVC = NotificationsTableViewController.instantiate(fromAppStoryboard: .HomeScreen)
            let nvc = UINavigationController(rootViewController: notificationsTVC)
            self.present(nvc, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let threadsVC = ContactTeacherViewController.instantiate(fromAppStoryboard: .Threads)
//            threadsVC.child = self.child
            
            self.navigationController?.pushViewController(threadsVC, animated: true)
        } else {
            let announcementsVc = AnnouncementTableViewController.instantiate(fromAppStoryboard: .Announcements)
            
            self.navigationController?.pushViewController(announcementsVc, animated: true)
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
                    debugPrint(result)
                    let notificationResponse = NotifcationResponse.init(fromDictionary: result)
                    
                    self.notificationSubTitleLabel.text = notificationResponse.notifications.first!.text!
                    if self.actor.unseenNotifications == 0 {
                        self.notificationBadge.isHidden = true
                    } else {
                        self.notificationBadge.isHidden = false
                        self.notificationBadge.text = "\(self.actor.unseenNotifications)"
                    }
//                    self.notifications.append(contentsOf: notificationResponse.notifications)
//                    self.meta = notificationResponse.meta
//                    self.tableView.reloadData()
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
    
    func getThreads(){
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_THREADS())
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    debugPrint(result)
//                    for thread in result
//                    {
//                        self.threads.append(Threads.init(fromDictionary: thread))
//                    }
//                    //                    self.refreshControl?.endRefreshing()
//                    self.threadsTableView.reloadData()
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
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }
    
    func getAnnouncements() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_ANNOUNCEMENTS(), 1, 1)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                debugPrint(response.result.value)
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    debugPrint(result)
                    //                    for thread in result
                    //                    {
                    //                        self.threads.append(Threads.init(fromDictionary: thread))
                    //                    }
                    //                    //                    self.refreshControl?.endRefreshing()
                    //                    self.threadsTableView.reloadData()
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
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: nil)
                }
            }
        }
    }

}
