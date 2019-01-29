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
import Firebase
import NRAppUpdate

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
        
        NRAppUpdate.checkUpdate(for: "1346646110") // check if there is

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
        
        self.notificationBadge.isHidden = true
        self.notificationSubTitleLabel.text = ""
        self.messageBadge.isHidden = true
        self.messagesSubTitleLabel.text = ""
        self.announccementBadge.isHidden = true
        self.announcementSubTitleLabel.text = ""
        
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.sendFCM(token: result.token)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setLocalization()
    }
    
    func sendFCM(token: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: EDIT_USER(), userId())
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
            case .success(_):
                //do nothing
                debugPrint("success")
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        self.refreshControl?.endRefreshing()})
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        self.refreshControl?.endRefreshing()})
                }
            }
        }
    }
    
    //service call to change localization
    func setLocalization() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        var locale = ""
        if Locale.current.languageCode!.elementsEqual("ar") {
            locale = "ar"
        } else {
            locale = "en"
        }
        let parameters: Parameters = ["user": ["language": locale]]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: EDIT_USER(), userId())
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
            self.getNotifcations()
            switch response.result{
            case .success(_):
                //do nothing
                debugPrint(response)
                
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        self.refreshControl?.endRefreshing()})
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        self.refreshControl?.endRefreshing()})
                }
            }
        }
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
            self.getThreads()
            
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [String: AnyObject]
                {
                    let notificationResponse = NotifcationResponse.init(fromDictionary: result)
                    if notificationResponse.notifications.isEmpty {
                        self.notificationSubTitleLabel.text = "No notifications".localized
                    } else {
                        self.notificationSubTitleLabel.text = notificationResponse.notifications.first?.text
                    }
                    
                    if self.actor.unseenNotifications == 0 {
                        self.notificationBadge.isHidden = true
                    } else {
                        self.notificationBadge.isHidden = false
                        debugPrint("\(self.actor.unseenNotifications!)")
                        self.notificationBadge.text = "\(self.actor.unseenNotifications!)"
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
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_THREADS())
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            self.getAnnouncements()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [String: AnyObject]
                {
                    debugPrint(result)
                    let unreadMessagesCount = result["unread_messages_count"] as! Int
                    if unreadMessagesCount == 0 {
                        self.messageBadge.isHidden = true
                    } else {
                        self.messageBadge.isHidden = false
                        self.messageBadge.text = "\(unreadMessagesCount)"
                    }
                    self.messagesSubTitleLabel.text = "No messages".localized
                    if let threadsJson = result["message_threads"] as? [[String : AnyObject]] {
                        var threads: [Threads] = []
                        for thread in threadsJson
                        {
                            threads.append(Threads.init(fromDictionary: thread))
                        }
                        
                        if !threads.isEmpty {
                            self.messagesSubTitleLabel.text = threads.first?.messages.first?.body.htmlToString
                        }

                    }
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
        let parameters : Parameters? = nil
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_ANNOUNCEMENTS(), 1, 1)
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
                
            case .success(_):
                if let result = response.result.value as? [String : AnyObject]
                {
                    self.announcementSubTitleLabel.text = "No announcements".localized
                    if let announcementsResponse =  result["announcements"] as? [[String: AnyObject]] {
                        var announcements: [Announcement] = []
                        for item in announcementsResponse {
                            let announcement = Announcement(fromDictionary: item)
                            announcements.append(announcement)
                        }
                        if !announcements.isEmpty {
                            self.announcementSubTitleLabel.text = announcements.first?.title
                        }
                        
                    }
                    debugPrint(result)
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
