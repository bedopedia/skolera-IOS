//
//  AnnouncementViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/14/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import Lightbox

class AnnouncementViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    //    @IBOutlet weak var announcementHeader: UILabel!
    //    @IBOutlet weak var annnouncementBody: UILabel!
    @IBOutlet weak var announcementImage: UIImageView!
    @IBOutlet weak var announcementHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var announcementWebView: UIWebView!
    
    var announcement: Announcement!
    var weeklyNote: GeneralNote!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        //        titleLabel.backgroundColor = .red
        if weeklyNote != nil {
            titleLabel.text = weeklyNote.title
            //        announcementHeader.text = announcement.title
            //        annnouncementBody.text = announcement.body.htmlToString
            announcementWebView.loadHTMLString(weeklyNote.description, baseURL: nil)
            
            if let image = weeklyNote.image, !image.isEmpty{
                self.announcementHeightConstraint.constant = 192
                self.announcementImage.isHidden = false
                let url = URL(string: image)
                announcementImage.kf.setImage(with: url)
                
            } else {
                self.announcementHeightConstraint.constant = 0
                self.announcementImage.isHidden = true
            }
        } else {
            titleLabel.text = announcement.title
            //        announcementHeader.text = announcement.title
            //        annnouncementBody.text = announcement.body.htmlToString
            announcementWebView.loadHTMLString(announcement.body, baseURL: nil)
            
            if announcement.imageURL == nil || announcement.imageURL.isEmpty {
                self.announcementHeightConstraint.constant = 0
                self.announcementImage.isHidden = true
            } else {
                self.announcementHeightConstraint.constant = 192
                self.announcementImage.isHidden = false
                let url = URL(string: announcement.imageURL)
                announcementImage.kf.setImage(with: url)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func displayImage() {
        var imageString = ""
        var titleString = ""
        if let myAnnouncement = announcement {
            imageString = myAnnouncement.imageURL
            titleString = myAnnouncement.title ?? ""
        } else if let myWeeklyNote = weeklyNote {
            imageString = myWeeklyNote.image ?? ""
            titleString = weeklyNote.title
        }
        if let url = URL(string: imageString) {
            let images = [
                LightboxImage(imageURL: url, text: titleString)
            ]
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.modalPresentationStyle = .fullScreen
            controller.dynamicBackground = true
            present(controller, animated: true, completion: nil)
        }
    }
    
}


extension AnnouncementViewController: LightboxControllerPageDelegate {
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        debugPrint(page)
    }
}

extension AnnouncementViewController: LightboxControllerDismissalDelegate {
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        //    dismiss(animated: false, completion: nil)
    }
}
