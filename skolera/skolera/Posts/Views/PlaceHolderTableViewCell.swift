//
//  PlaceHolderTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 11/14/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class PlaceHolderTableViewCell: UITableViewCell {

    @IBOutlet var placeHolderView: UIView!
    @IBOutlet var placeHolderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
