//
//  EventTypeCollectionViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 8/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class EventTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var eventButton: UIButton!
    @IBOutlet weak var bottomBar: UIView!
    
    var cellNumber = 0 {
        didSet{
            switch cellNumber {
            case 0:
                numberLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                bottomBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                eventButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                eventButton.setTitle("All".localized, for: .normal)
            case 1:
                numberLabel.textColor = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1)
                bottomBar.backgroundColor = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1)
                eventButton.setTitleColor(#colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1), for: .normal)
                eventButton.setTitle("Academic".localized, for: .normal)
            case 2:
                numberLabel.textColor = #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1)
                bottomBar.backgroundColor = #colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1)
                eventButton.setTitleColor(#colorLiteral(red: 0.04705882353, green: 0.768627451, blue: 0.8, alpha: 1), for: .normal)
                eventButton.setTitle("Events".localized, for: .normal)
            case 3:
                numberLabel.textColor = #colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1)
                bottomBar.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1)
                eventButton.setTitleColor(#colorLiteral(red: 0.4078431373, green: 0.737254902, blue: 0.4235294118, alpha: 1), for: .normal)
                eventButton.setTitle("Vacations".localized, for: .normal)
            case 4:
                numberLabel.textColor = #colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1)
                bottomBar.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1)
                eventButton.setTitleColor(#colorLiteral(red: 0.4705882353, green: 0.3215686275, blue: 0.7490196078, alpha: 1), for: .normal)
                eventButton.setTitle("Personal".localized, for: .normal)
            
            default:
                debugPrint("default")
                
            }
        }
    }
    
}
