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
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.sendFCM(token: result.token)
            }
        }
        
    }
    
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
