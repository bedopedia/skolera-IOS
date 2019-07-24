//
//  QuizCourseTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizCourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var assignmentName: UILabel!
    @IBOutlet weak var assignmentDateView: UIView!
    @IBOutlet weak var assignmentClockImage: UIImageView!
    @IBOutlet weak var assignmentDateLabel: UILabel!
    @IBOutlet weak var numberOfAssignmentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
