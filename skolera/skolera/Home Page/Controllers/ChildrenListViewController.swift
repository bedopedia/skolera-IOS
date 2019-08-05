//
//  HomeScreenTableTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/30/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import KeychainSwift
import SVProgressHUD
import Alamofire
import Kingfisher
import Firebase



class ChildrenListViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: - Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    /// children array acts as the data source for the tableView
    @IBOutlet weak var notificationButton: UIButton!
//    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var kids = [Child]()
    //MARK: - Life Cycle
    /// sets basic screen defaults, dynamic row height, clears the back button
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
//        signOutButton.image = signOutButton.image?.flipIfNeeded()
//        navigationController?.isNavigationBarHidden = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getChildren), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
//        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
//        let backItem = UIBarButtonItem()
//        backItem.title = nil
//        navigationItem.backBarButtonItem = backItem
        getChildren()
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.sendFCM(token: result.token)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        notificationButton.setImage(UIImage(named: UIApplication.shared.applicationIconBadgeNumber == 0 ? "notifications" :  "unSeenNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    // MARK: - Table view settings
    
    /// sevice call to set firebase token
    func sendFCM(token: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    
    /// service call to get parent children, it adds them to the children array
    @objc func getChildren() {
        self.refreshControl.endRefreshing()
        SVProgressHUD.show(withStatus: "Loading".localized)
        getChildrenAPI(parentId: Int(parentId())!) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.kids = []
                    for child in result {
                        self.kids.append(Child.init(fromDictionary: child))
                    }
                    self.tableView.reloadData()
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    
    
    func showChangeLanguageConfirmation(language: Language){
        let alert = UIAlertController(title: "Restart Required".localized, message: "This requires restarting the Application.\nAre you sure you want to close the app now?".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { action in
            Language.language = language
            exit(0);
        }))
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Actions
    
    /// logs out user by clearing his date from keychain, navigate to the school code screen
    ///
    /// - Parameter sender: logout button
    @IBAction func logout() {
        let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
            if Language.language == .arabic {
                self.showChangeLanguageConfirmation(language: .english)
            } else{
                self.showChangeLanguageConfirmation(language: .arabic)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
            if(SVProgressHUD.isVisible()) {
                SVProgressHUD.dismiss()
            }
            self.sendFCM(token: "")
            let keychain = KeychainSwift()
            keychain.clear()
            let nvc = UINavigationController()
            let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            nvc.pushViewController(schoolCodeVC, animated: true)
            self.present(nvc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// shows notification screen modally
    ///
    /// - Parameter sender: notification button
    @IBAction func showNotifications() {
        if(SVProgressHUD.isVisible()){
            SVProgressHUD.dismiss()
        }
        let notificationsTVC = NotificationsTableViewController.instantiate(fromAppStoryboard: .HomeScreen)
        let nvc = UINavigationController(rootViewController: notificationsTVC)
        self.present(nvc, animated: true, completion: nil)
    }
    
    /// refreshes table if user dragged table down for refresh
    ///
    /// - Parameter sender: table refresh control
    @IBAction func refresh(_ sender: UIRefreshControl) {
        self.refreshControl?.beginRefreshing()
        kids.removeAll()
        getChildren()
    }
}

extension ChildrenListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }
    
    
    /// picks a child from children array by its index and fill a cell with his data
    ///
    /// - Parameters:
    ///   - tableView: the screen tableviw
    ///   - indexPath: the section and row of the cell
    /// - Returns: ChildrenTableViewCell filled with its contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as! ChildrenTableViewCell
        cell.child = kids[indexPath.row]
        return cell
    }
    
    /// navigate to the child profile screen for the selected child
    ///
    /// - Parameters:
    ///   - tableView: the screen tableview
    ///   - indexPath: cell row and section
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChildrenTableViewCell
        let childProfileVC = ChildHomeViewController.instantiate(fromAppStoryboard: .HomeScreen)
        childProfileVC.child = cell.child
        childProfileVC.assignmentsText = ""
        childProfileVC.quizzesText = ""
        childProfileVC.eventsText = ""
        self.navigationController?.pushViewController(childProfileVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
}
