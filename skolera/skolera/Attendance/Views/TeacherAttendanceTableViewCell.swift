//
//  TeacherAttendanceTableViewCell.swift
//  skolera
//
//  Created by Rana Hossam on 9/1/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherAttendanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentSelectButton: UIButton!
    @IBOutlet weak var studentImageView: UIImageView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var presentButton: UIButton!
    @IBOutlet weak var lateButton: UIButton!
    @IBOutlet weak var absentButton: UIButton!
    @IBOutlet weak var excusedButton: UIButton!
    
    var didSelectStudent: ( () -> () )!
    var didSelectAttendanceState: ( (AttendanceCases) -> () )!
    
//    var behaviorNote: BehaviorNote!{
//        didSet{
//            if behaviorNote != nil
//            {
//                categoryLabel.text = behaviorNote.category
//                senderLabel.text = behaviorNote.owner.name
//                contentLabel.text = behaviorNote.note.withoutHTMLTags().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//            }
//            
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func studentSelectedButtonAction() {
        didSelectStudent()
    }
    

    
    @IBAction func presentButtonAction() {
        didSelectAttendanceState(.present)
    }
    
    @IBAction func lateButtonAction() {
        didSelectAttendanceState(.late)
    }
    
    @IBAction func absentButtonAction() {
        didSelectAttendanceState(.absent)
    }
    
    @IBAction func excusedButtonAction() {
        didSelectAttendanceState(.excused)
    }
    
    

}
