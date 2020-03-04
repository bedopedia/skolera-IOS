//
//  SelectionTableViewCell.swift
//  skolera
//
//  Created by Salma Medhat on 3/4/20.
//  Copyright © 2020 Skolera. All rights reserved.
//

import UIKit
import SkeletonView

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
