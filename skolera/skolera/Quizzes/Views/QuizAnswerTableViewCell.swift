
//
//  QuizAnswrTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class QuizAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var matchLeftView: UIView!
    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var answerTextLabel: UILabel!
    @IBOutlet weak var answerLeftImageView: UIImageView!
    @IBOutlet weak var answerRightImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
