//
//  HomeScreenTableTableViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/30/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import Firebase
import NVActivityIndicatorView

class ChildrenListViewController: UIViewController, UIGestureRecognizerDelegate, NVActivityIndicatorViewable {
    //MARK: - Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    /// children array acts as the data source for the tableView
    @IBOutlet weak var notificationButton: UIButton!
    var kids: [Actor]!
    var userId: Int!
    var expendedPositions: [Int] = [0]
    //MARK: - Life Cycle
    /// sets basic screen defaults, dynamic row height, clears the back button
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        notificationButton.setImage(UIImage(named: UIApplication.shared.applicationIconBadgeNumber == 0 ? "notifications" :  "unSeenNotification")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    


    // MARK: - Table view settings
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
        let settingsVC = SettingsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        navigationController?.pushViewController(settingsVC, animated: true)
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
        cell.hideSkeleton()
        cell.child = kids[indexPath.row]
        cell.isExpanded = expendedPositions.contains(indexPath.row)
        if cell.isExpanded {
            cell.expantionButton.setImage(#imageLiteral(resourceName: "arrow_down").rotatedImage(), for: .normal)
        } else {
            cell.expantionButton.setImage(#imageLiteral(resourceName: "arrow_down"), for: .normal)
        }
        debugPrint("EXPAND:", expendedPositions)
        cell.didExpandItem = {
            if self.expendedPositions.contains(indexPath.row) {
                if let index = self.expendedPositions.index(of: indexPath.row) {
                    self.expendedPositions.remove(at: index)
                }
            } else {
                self.expendedPositions.append(indexPath.row)
            }
             self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ChildrenTableViewCell
        let tabBarVC = TabBarViewController.instantiate(fromAppStoryboard: .HomeScreen)
        tabBarVC.actor = cell.child
        tabBarVC.assignmentsText = ""
        tabBarVC.quizzesText = ""
        tabBarVC.eventsText = ""
        self.navigationController?.pushViewController(tabBarVC, animated: true)
    }

    
    
}
