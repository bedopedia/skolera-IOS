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
    
    func presentSelected() {
        resetAll()
        presentButton.setImage(#imageLiteral(resourceName: "presentSelected"), for: .normal)
        presentButton.backgroundColor = #colorLiteral(red: 0.8235294118, green: 0.937254902, blue: 0.8039215686, alpha: 1)
        presentButton.setTitleColor(#colorLiteral(red: 0.4, green: 0.7333333333, blue: 0.4156862745, alpha: 1), for: .normal)
       
    }
    
    func lateSelected() {
        resetAll()
        lateButton.setImage(#imageLiteral(resourceName: "lateSelected"), for: .normal)
        lateButton.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9098039216, blue: 0.737254902, alpha: 1)
        lateButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.7529411765, blue: 0.1764705882, alpha: 1), for: .normal)
    }
    
    func absentSelected() {
        resetAll()
        absentButton.setImage(#imageLiteral(resourceName: "absentSelected"), for: .normal)
        absentButton.backgroundColor = #colorLiteral(red: 1, green: 0.8784313725, blue: 0.8745098039, alpha: 1)
        absentButton.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.5098039216, blue: 0.4078431373, alpha: 1), for: .normal)
    }
    
    func excusedSelected() {
        resetAll()
        excusedButton.setImage(#imageLiteral(resourceName: "excusedSelected"), for: .normal)
        excusedButton.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.8705882353, blue: 0.9803921569, alpha: 1)
        excusedButton.setTitleColor(#colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1), for: .normal)
    }
    
    
    func resetAll() {
        
        studentSelectButton.layer.borderWidth = 1
        studentSelectButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        studentSelectButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        lateButton.setImage(#imageLiteral(resourceName: "late"), for: .normal)
        lateButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        lateButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
        
        presentButton.setImage(#imageLiteral(resourceName: "present"), for: .normal)
        presentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        presentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
        
        excusedButton.setImage(#imageLiteral(resourceName: "excused"), for: .normal)
        excusedButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        excusedButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
        
        absentButton.setImage(#imageLiteral(resourceName: "absent"), for: .normal)
        absentButton.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        absentButton.setTitleColor(#colorLiteral(red: 0.5843137255, green: 0.5843137255, blue: 0.5843137255, alpha: 1), for: .normal)
    }
    
    func applyState(attendanceCase: AttendanceCases) {
        resetAll()
        switch (attendanceCase) {
        case .absent:
            absentSelected()
        case .present:
            presentSelected()
        case .late:
            lateSelected()
        case .excused:
            excusedSelected()
        }
    }
    
    func selectStudent() {
        studentSelectButton.backgroundColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
        studentSelectButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4941176471, blue: 0.8980392157, alpha: 1)
    }
    
    func deselectStudent() {
        studentSelectButton.layer.borderWidth = 1
        studentSelectButton.layer.borderColor = #colorLiteral(red: 0.6470588235, green: 0.6784313725, blue: 0.7058823529, alpha: 1)
        studentSelectButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

}
