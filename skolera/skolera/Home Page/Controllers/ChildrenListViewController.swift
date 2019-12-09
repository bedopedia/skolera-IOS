//
//  HomeScreenTableTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/30/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import KeychainSwift
import Alamofire
import Kingfisher
import Firebase
import NVActivityIndicatorView
import SkeletonView

class ChildrenListViewController: UIViewController, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {
    //MARK: - Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    /// children array acts as the data source for the tableView
    @IBOutlet weak var notificationButton: UIButton!
//    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var kids = [Child]()
    //MARK: - Life Cycle
    /// sets basic screen defaults, dynamic row height, clears the back button
    override func viewDidLoad() {
        super.viewDidLoad()
//        signOutButton.image = signOutButton.image?.flipIfNeeded()
//        navigationController?.isNavigationBarHidden = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        headerView.addShadow()
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
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
            if isSuccess {
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    /// service call to get parent children, it adds them to the children array
    @objc func getChildren() {
        self.tableView.showAnimatedSkeleton()
        getChildrenAPI(parentId: Int(parentId())!) { (isSuccess, statusCode, value, error) in
            self.tableView.hideSkeleton()
            if isSuccess {
                if let result = value as? [[String : AnyObject]] {
                    self.kids = []
                    for child in result {
                        self.kids.append(Child.init(fromDictionary: child))
                    }
                    self.tableView.rowHeight = UITableViewAutomaticDimension
                    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
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
        alert.modalPresentationStyle = .fullScreen
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
            if(self.isAnimating) {
                self.stopAnimating()
            }
            self.sendFCM(token: "")
            let keychain = KeychainSwift()
            keychain.clear()
            let nvc = UINavigationController()
            let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            nvc.pushViewController(schoolCodeVC, animated: true)
            nvc.modalPresentationStyle = .fullScreen
            self.present(nvc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    
    /// shows notification screen modally
    ///
    /// - Parameter sender: notification button
    @IBAction func showNotifications() {
        if(self.isAnimating){
            self.stopAnimating()
        }
        let notificationsVC = NotificationsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        notificationsVC.fromChildrenList = true
        self.navigationController?.pushViewController(notificationsVC, animated: true)
    }
}

extension ChildrenListViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
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
        cell.hideSkeleton()
        cell.child = kids[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChildrenTableViewCell
        let tabBarVC = TabBarViewController.instantiate(fromAppStoryboard: .HomeScreen)
        tabBarVC.child = cell.child
        tabBarVC.assignmentsText = ""
        tabBarVC.quizzesText = ""
        tabBarVC.eventsText = ""
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "childCell"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}
