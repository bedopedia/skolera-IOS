//
//  WeeklyInfoTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 3/6/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class WeeklyInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.masksToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2);
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
