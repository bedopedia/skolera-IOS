//
//  NotificationTableViewCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/31/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationDetailsLabel: UILabel!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    //MARK: - Variables
    /// notification variable contains cell data, once set it fills cell contents
    var notification: Notification! {
        didSet{
            //cell title and child name(if any)
            notificationDetailsLabel.text = notification.text
            if let additionalParams = notification.additionalParams
            {
                studentNameLabel.text = additionalParams.studentNames.first
            }
            else
            {
                studentNameLabel.text = ""
            }
            //notification image
            notificationImageView.image = getImage(type: notification.message)
            //parsing date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
            let date = dateFormatter.date(from: notification.createdAt)!
            //showing date
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            dateTimeLabel.text = dateFormatter.string(from: date)
        }
    }
    //MARK: -Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    /// Returns the notification image based on its type
    ///
    /// - Parameter message: message type
    /// - Returns: notification image
    func getImage(type message: String) -> UIImage
    {
        if message.contains("graded")
        {
            return #imageLiteral(resourceName: "grades")
        }
        else if message.contains("assignments")
        {
            return #imageLiteral(resourceName: "assignmentsIco")
        }
        else if message.contains("quizzes")
        {
            return #imageLiteral(resourceName: "quizzesIco")
        }
        else if message.contains("zones")
        {
            return #imageLiteral(resourceName: "zones")
        }
        else if message.contains("events")
        {
            return #imageLiteral(resourceName: "mydaysIco")
        }
        else if message.contains("virtual")
        {
            return #imageLiteral(resourceName: "virtualclass")
        }
        else
        {
            return #imageLiteral(resourceName: "notifications")
        }
    }
    
    func showShimmer() {
        notificationImageView.showAnimatedSkeleton()
        notificationDetailsLabel.showAnimatedSkeleton()
        studentNameLabel.showAnimatedSkeleton()
        dateTimeLabel.showAnimatedSkeleton()
//        notificationImageView.showAnimatedGradientSkeleton()
//        notificationDetailsLabel.showAnimatedGradientSkeleton()
//        studentNameLabel.showAnimatedGradientSkeleton()
//        dateTimeLabel.showAnimatedGradientSkeleton()
    }
    
}
