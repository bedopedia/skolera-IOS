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
import NRAppUpdate


class ChildrenTableViewController: UITableViewController {
    //MARK: - Variables
    
    /// children array acts as the data source for the tableView
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    var kids = [Child]()
    //MARK: - Life Cycle
    /// sets basic screen defaults, dynamic row height, clears the back button
    override func viewDidLoad() {
        super.viewDidLoad()
        NRAppUpdate.checkUpdate(for: "1346646110") // check if there is updates for app in store
        signOutButton.image = signOutButton.image?.flipIfNeeded()
        navigationController?.isNavigationBarHidden = false
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        getChildren()
        setLocalization()
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
        notificationButton.image = UIImage(named: UIApplication.shared.applicationIconBadgeNumber == 0 ? "notifications" :  "unSeenNotification")?.withRenderingMode(.alwaysOriginal)
    }
    // MARK: - Table view settings
    
    /// sevice call to set firebase token
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
    
    /// service call to get parent children, it adds them to the children array
    func getChildren()
    {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters : Parameters = ["parent_id" : parentId()]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: GET_CHILDREN(),parentId())
        Alamofire.request(url, method: .get, parameters: parameters, headers: headers).validate().responseJSON { response in
            SVProgressHUD.dismiss()
            switch response.result{
            
            case .success(_):
                if let result = response.result.value as? [[String : AnyObject]]
                {
                    for child in result
                    {
                        self.kids.append(Child.init(fromDictionary: child))
                    }
                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kids.count
    }
    
    
    /// picks a child from children array by its index and fill a cell with his data
    ///
    /// - Parameters:
    ///   - tableView: the screen tableviw
    ///   - indexPath: the section and row of the cell
    /// - Returns: ChildrenTableViewCell filled with its contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "childCell", for: indexPath) as! ChildrenTableViewCell
        
        let child = kids[indexPath.row]
        cell.child = child
        
        return cell
    }
    
    /// navigate to the child profile screen for the selected child
    ///
    /// - Parameters:
    ///   - tableView: the screen tableview
    ///   - indexPath: cell row and section
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChildrenTableViewCell
        let childProfileVC = ChildProfileViewController.instantiate(fromAppStoryboard: .HomeScreen)
        childProfileVC.child = cell.child
        childProfileVC.assignmentsText = cell.assignmentsLabel.text
        childProfileVC.quizzesText = cell.quizzesLabel.text
        childProfileVC.eventsText = cell.eventsLabel.text
        self.navigationController?.pushViewController(childProfileVC, animated: true)
    }
    
    func showChangeLanguageConfirmation(language: Language){
        let alert = UIAlertController(title: "Restart Required".localized, message: "This requires restarting the Application.\nAre you sure you want to close the app now?".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { action in
            Language.language = language
            exit(0);
        }))
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: { action in
            // do nothing
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    // MARK: - Actions
    
    /// logs out user by clearing his date from keychain, navigate to the school code screen
    ///
    /// - Parameter sender: logout button
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
            if Language.language == .arabic {
                self.showChangeLanguageConfirmation(language: .english)
            } else{
                self.showChangeLanguageConfirmation(language: .arabic)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
            if(SVProgressHUD.isVisible())
            {
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
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    /// shows notification screen modally
    ///
    /// - Parameter sender: notification button
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        if(SVProgressHUD.isVisible())
        {
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
