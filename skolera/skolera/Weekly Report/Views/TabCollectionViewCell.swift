//
//  TabCollectionViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 3/5/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var selectedDayView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func selectDay() {
        selectedDayView.isHidden = false
        dayLabel.textColor = UIColor.init(red: 40/255, green: 187/255, blue: 78/255, alpha: 1.0)
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    func deSelectDay() {
        selectedDayView.isHidden = true
        dayLabel.textColor = UIColor.init(red: 185/255, green: 185/255, blue: 185/255, alpha: 1.0)
        dayLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}
