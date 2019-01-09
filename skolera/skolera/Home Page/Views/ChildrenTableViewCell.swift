//
//  ChildrenTableViewCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/30/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class ChildrenTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var StudentGradeLabel: UILabel!
    @IBOutlet weak var attendanceDotView: UIView!
    @IBOutlet weak var attendanceLabel: UILabel!
    @IBOutlet weak var quizzesLabel: UILabel!
    @IBOutlet weak var assignmentsLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    /// The child variable contains cell data, once set it fills cells contents
    var child: Child!{
        didSet{
            if child != nil{
                
                studentNameLabel.text = child.name
                StudentGradeLabel.text = child.levelName
                studentImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 18)
                setAttendanceDotView()
                //setting attendance Label
                child.todayWorkloadStatus.attendanceStatus.capitalizeFirstLetter()
                attendanceLabel.text = child.todayWorkloadStatus.attendanceStatus
                
                //setting todays workload
                quizzesLabel.text = "\(child.todayWorkloadStatus.quizzesCount!) \("Quizzes".localized)".localizedCapitalized
                assignmentsLabel.text = "\(child.todayWorkloadStatus.assignmentsCount!) \("Assignments".localized)".localizedCapitalized
                eventsLabel.text = "\(child.todayWorkloadStatus.eventsCount!) \("Events".localized)".localizedCapitalized
            }
        }
    }
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: - Methods
    
    /// Adds a dotted circle to represent attendance status
    fileprivate func setAttendanceDotView() {
        switch child.todayWorkloadStatus.attendanceStatus
        {
        case "present":
            self.attendanceDotView.backgroundColor = UIColor.appColors.green
        case "absent":
            self.attendanceDotView.backgroundColor = UIColor.appColors.red
        case "late":
            self.attendanceDotView.backgroundColor = UIColor.appColors.purple
        case "excused":
            self.attendanceDotView.backgroundColor = UIColor.appColors.orange
        default:
            self.attendanceDotView.backgroundColor = UIColor.appColors.greyNotTaken
        }
        attendanceDotView.layer.cornerRadius = attendanceDotView.frame.height/2
    }
    
}
