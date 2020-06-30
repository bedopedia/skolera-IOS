//
//  SenderTextChatTableViewCell.swift
//  Skolera
//
//  Created by Salma Medhat on 6/30/20.
//  Copyright © 2019 Trianglz. All rights reserved.
//

import UIKit

class SenderTextChatTableViewCell: UITableViewCell {

    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.messageContainer.roundCorners([.topRight, .topLeft, .bottomLeft], radius: 22)
        }
    }
    
    override func prepareForReuse() {
        DispatchQueue.main.async {
            self.messageContainer.roundCorners([.topRight, .topLeft, .bottomLeft], radius: 22)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
