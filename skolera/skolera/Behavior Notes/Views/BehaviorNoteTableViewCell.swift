//
//  BehaviorNoteTableViewCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class BehaviorNoteTableViewCell: UITableViewCell {

    //MARK:- Variables
    var behaviorNote: BehaviorNote!{
        didSet{
            if behaviorNote != nil
            {
                contentLabel.isHidden = false
                categoryLabel.text = behaviorNote.category
                senderLabel.text = behaviorNote.owner.name
                contentLabel.text = behaviorNote.note.withoutHTMLTags().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            
        }
    }
    //MARK:- Outlets
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
//        contentLabel.text = " "
//        categoryLabel.text = " "
//        senderLabel.text = " "
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentLabel.isHidden = true
        categoryLabel.text = "dummy text"
        senderLabel.text = "dummy text"
    }

}
