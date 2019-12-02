//
//  ThreadTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 5/20/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit


class ThreadTableViewCell: UITableViewCell {
    @IBOutlet weak var threadImage: UIImageView!
    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var threadLatestMessage: UILabel!
    @IBOutlet weak var threadDate: UILabel!
    @IBOutlet weak var unSeenView: UIView!
    @IBOutlet weak var unSeenCntLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unSeenView.layer.cornerRadius = unSeenView.width/2
        unSeenView.layer.masksToBounds = true
        unSeenView.isHidden = true
        unSeenCntLabel.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        threadImage.childImageView(url: "" , placeholder: "", textSize: 20, borderWidth: 0)
    }
    
    

}
