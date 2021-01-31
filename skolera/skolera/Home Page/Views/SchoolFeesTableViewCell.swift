//
//  SchoolFeesTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 13/01/2021.
//  Copyright © 2021 Skolera. All rights reserved.
//

import UIKit

class SchoolFeesTableViewCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var schoolFee: SchoolFees! {
        didSet{
            if schoolFee != nil {
                senderLabel.text = schoolFee.name
                categoryLabel.text = schoolFee.studentName
                contentLabel.text = schoolFee.amount
                dateLabel.text = schoolFee.dueDate
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
