//
//  ChildHomeViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/16/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class ChildHomeViewController: UIViewController {
    
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var threadsView: UIView!
    @IBOutlet weak var announcementsView: UIView!
    
    
    //MARK: - Variables
    var child: Child!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let childVc = childViewControllers[0] as? ChildProfileViewController {
            childVc.child = self.child
            childVc.assignmentsText = self.assignmentsText
            childVc.quizzesText = self.quizzesText
            childVc.eventsText = self.eventsText
            childVc.addChildImage()
            childVc.addChildData()
        }
        selectMenu()
    }
    
    private func unSelectAllTabs(){
        navigationItem.rightBarButtonItem = nil
        moreView.isHidden = true
        notificationView.isHidden = true
        threadsView.isHidden = true
        announcementsView.isHidden = true
    }
    
    @IBAction func selectAnnouncments(){
        unSelectAllTabs()
        announcementsView.isHidden = false
    }
    
    @IBAction func selectMessages(){
        unSelectAllTabs()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMessage))
        threadsView.isHidden = false
    }
    @IBAction func selectNotification(){
        unSelectAllTabs()
        notificationView.isHidden = false
    }
    
    
    @IBAction func selectMenu(){
        unSelectAllTabs()
        moreView.isHidden = false
    }
    
    @objc func newMessage() {
        let newMessageVC = NewMessageViewController.instantiate(fromAppStoryboard: .Threads)
        newMessageVC.child = self.child
        self.navigationController?.pushViewController(newMessageVC, animated: true)
    }
}
