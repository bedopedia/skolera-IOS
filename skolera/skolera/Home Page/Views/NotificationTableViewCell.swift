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
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var gradientView: GradientView!
    //MARK: - Variables
    /// notification variable contains cell data, once set it fills cell contents
    var notification: Notification! {
        didSet{
            //cell title and child name(if any)
            notificationDetailsLabel.text = notification.text
            //notification image
            notificationImageView.image = getImage(type: notification.message)
            //parsing date
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: notification.createdAt)!
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "dd MMM yyyy"
            dateTimeLabel.text = newDateFormat.string(from: date)
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
            return #imageLiteral(resourceName: "grade_icon")
        }
        else if message.contains("assignments")
        {
            return #imageLiteral(resourceName: "assignment_icon")
        }
        else if message.contains("quizzes")
        {
            return #imageLiteral(resourceName: "quiz_icon")
        }
        else if message.contains("zones")
        {
            return #imageLiteral(resourceName: "zones_icon")
        }
        else if message.contains("events")
        {
            return #imageLiteral(resourceName: "event")
        }
        else if message.contains("virtual")
        {
            return #imageLiteral(resourceName: "class_icon")
        }
        else
        {
            return #imageLiteral(resourceName: "notification_light_icon")
        }
    }
    
    func showShimmer() {
        notificationImageView.showAnimatedSkeleton()
        notificationDetailsLabel.showAnimatedSkeleton()
//        studentNameLabel.showAnimatedSkeleton()
        dateTimeLabel.showAnimatedSkeleton()
        gradientView.showAnimatedSkeleton()
//        notificationImageView.showAnimatedGradientSkeleton()
//        notificationDetailsLabel.showAnimatedGradientSkeleton()
//        studentNameLabel.showAnimatedGradientSkeleton()
//        dateTimeLabel.showAnimatedGradientSkeleton()
    }
    
}
