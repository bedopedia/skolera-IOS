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
    
    var actor: Actor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NRAppUpdate.checkUpdate(for: "1346646110") // check if there is

        
        
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            let notificationsTVC = NotificationsTableViewController.instantiate(fromAppStoryboard: .HomeScreen)
//            let nvc = UINavigationController(rootViewController: notificationsTVC)
//            self.present(nvc, animated: true, completion: nil)
//        } else if indexPath.row == 1 {
//            let threadsVC = ContactTeacherViewController.instantiate(fromAppStoryboard: .Threads)
////            threadsVC.child = self.child
//            
//            self.navigationController?.pushViewController(threadsVC, animated: true)
//        } else {
//            let announcementsVc = AnnouncementTableViewController.instantiate(fromAppStoryboard: .Announcements)
//            
//            self.navigationController?.pushViewController(announcementsVc, animated: true)
//        }
    }
    
}
