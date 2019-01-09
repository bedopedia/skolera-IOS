//
//  GradeHeaderTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 5/30/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class GradeHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleNameLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var totalGradeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
