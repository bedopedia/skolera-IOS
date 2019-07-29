//
//  AssignmentTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 4/22/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var dueDayLabel: UILabel!
    @IBOutlet weak var dueMonthLabel: UILabel!
    @IBOutlet weak var assignmentDateView: UIView!
    @IBOutlet weak var assignmentClockImage: UIImageView!
    @IBOutlet weak var assignmentDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var assignment: FullAssignment! {
        didSet {
            titleLabel.text = assignment.name
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
            let assignDate = dateFormatter.date(from: assignment.startAt)
            let endDate = dateFormatter.date(from: assignment.endAt)
            let newDateFormat = DateFormatter()
            newDateFormat.dateFormat = "dd MMM YYYY"
            if Language.language == .arabic {
                publishDateLabel.text = "نشر " + newDateFormat.string(from: assignDate!)
            } else {
                publishDateLabel.text = "published \(newDateFormat.string(from: assignDate!))"
            }
            newDateFormat.dateFormat = "dd"
            dueDayLabel.text = newDateFormat.string(from: endDate!)
            newDateFormat.dateFormat = "MMM"
            dueMonthLabel.text = newDateFormat.string(from: endDate!)
            
            if let assignStringDate = assignment.endAt {
                assignmentDateView.isHidden = false
                assignmentDateLabel.isHidden = false
                assignmentClockImage.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let assignDate = dateFormatter.date(from: assignStringDate)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "d MMM, yyyy, h:mm a"
                assignmentDateLabel.text = newDateFormat.string(from: assignDate!)
                if assignment.state.elementsEqual("running") {
                    assignmentDateView.backgroundColor = #colorLiteral(red: 0.8247086406, green: 0.9359105229, blue: 0.8034248352, alpha: 1)
                    assignmentDateLabel.textColor = #colorLiteral(red: 0.1179271713, green: 0.2293994129, blue: 0.09987530857, alpha: 1)
                    assignmentClockImage.image = #imageLiteral(resourceName: "greenHour")
                } else {
                    assignmentDateView.backgroundColor = #colorLiteral(red: 0.9988667369, green: 0.8780437112, blue: 0.8727210164, alpha: 1)
                    assignmentDateLabel.textColor = #colorLiteral(red: 0.4231846929, green: 0.243329376, blue: 0.1568627451, alpha: 1)
                    assignmentClockImage.image = #imageLiteral(resourceName: "1")
                }
            } else {
                assignmentDateView.isHidden = true
                assignmentDateLabel.isHidden = true
                assignmentClockImage.isHidden = true
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
