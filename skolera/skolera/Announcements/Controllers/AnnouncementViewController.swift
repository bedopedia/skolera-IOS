//
//  AnnouncementViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/14/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AnnouncementViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var announcementHeader: UILabel!
//    @IBOutlet weak var annnouncementBody: UILabel!
    @IBOutlet weak var announcementImage: UIImageView!
    @IBOutlet weak var announcementHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var announcementWebView: UIWebView!
    
    var announcement: Announcement!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = announcement.title
//        announcementHeader.text = announcement.title
//        annnouncementBody.text = announcement.body.htmlToString
        announcementWebView.loadHTMLString(announcement.body, baseURL: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.appColors.dark
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        if announcement.imageURL == nil || announcement.imageURL.isEmpty {
            self.announcementHeightConstraint.constant = 0
            self.announcementImage.isHidden = true
        } else {
            self.announcementHeightConstraint.constant = 192
            self.announcementImage.isHidden = false
            let url = URL(string: announcement.imageURL)
            announcementImage.kf.setImage(with: url)
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
