//
//  GradeDetailTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 5/30/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class GradeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var avgGradeLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var gradeWorldLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
