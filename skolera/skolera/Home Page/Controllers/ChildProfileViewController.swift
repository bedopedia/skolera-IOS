//
//  ChildProfileViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/27/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
class ChildProfileViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var childImageOuterView: UIView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childGradeLabel: UILabel!
    @IBOutlet weak var quizzesLabel: UILabel!
    @IBOutlet weak var assignmentsLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    
    //MARK: - Variables
    var child: Child!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!
    
    //MARK: - Life Cycle
    
    /// sets basic screen details, sends current child to embedded ChildProfileFeaturesTableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        
        addChildImage()
        if let child = child{
            childNameLabel.text = child.name
            childGradeLabel.text = child.levelName
        }
        if let assignmentsText = assignmentsText{
            assignmentsLabel.text = assignmentsText
        }
        if let quizzesText = quizzesText{
            quizzesLabel.text = quizzesText
        }
        if let eventsText = eventsText{
            eventsLabel.text = eventsText
        }
        let featureTVC = childViewControllers[0] as! ChildProfileFeaturesTableViewController
        featureTVC.child = child
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notificationButton.image = UIImage(named: UIApplication.shared.applicationIconBadgeNumber == 0 ? "notifications" :  "unSeenNotification")?.withRenderingMode(.alwaysOriginal)
    }

    //MARK: - methods
    
    /// draws the child image with rounded green glow
    private func addChildImage()
    {
        //sets outer view to generate the green glow
        childImageOuterView.clipsToBounds = false
        childImageOuterView.layer.shadowColor = UIColor.appColors.green.cgColor
        childImageOuterView.layer.shadowOpacity = 0.5
        childImageOuterView.layer.shadowOffset = CGSize.zero
        childImageOuterView.layer.shadowRadius = 10
        childImageOuterView.layer.shadowPath = UIBezierPath(roundedRect: childImageOuterView.bounds, cornerRadius: childImageOuterView.frame.height/2 ).cgPath
        //gets inner child image view
        let childImageView = UIImageView(frame: childImageOuterView.bounds)
        childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 32)
        childImageOuterView.backgroundColor = nil
        childImageOuterView.addSubview(childImageView)
        //sets image frame to the outer frame
        NSLayoutConstraint.activate([childImageView.leadingAnchor.constraint(equalTo: childImageOuterView.leadingAnchor),childImageView.topAnchor.constraint(equalTo: childImageOuterView.topAnchor)])
    }
    
    
    
    //MARK: - Actions
    
    /// show notification screen modally
    ///
    /// - Parameter sender: notification button
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        let notificationsTVC = NotificationsTableViewController.instantiate(fromAppStoryboard: .HomeScreen)
        let nvc = UINavigationController(rootViewController: notificationsTVC)
        self.present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func openThreads(){
        
        let threadsVC = ContactTeacherViewController.instantiate(fromAppStoryboard: .Threads)
        threadsVC.child = self.child
        
        self.navigationController?.pushViewController(threadsVC, animated: true)
    }

}
