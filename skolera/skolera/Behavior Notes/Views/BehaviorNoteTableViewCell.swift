//
//  BehaviorNoteTableViewCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/28/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class BehaviorNoteTableViewCell: UITableViewCell 
{

    //MARK:- Variables
    var behaviorNote: BehaviorNote!{
        didSet{
            if behaviorNote != nil
            {
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

}
