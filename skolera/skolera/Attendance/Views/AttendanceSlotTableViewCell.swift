//
//  AttendanceSlotTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AttendanceSlotTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var slotLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
