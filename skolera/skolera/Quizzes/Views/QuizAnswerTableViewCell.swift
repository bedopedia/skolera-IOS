
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
        
        matchLeftView.layer.borderWidth = 1
        matchLeftView.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        matchLeftView.layer.cornerRadius = 6
//        matchLeftView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
