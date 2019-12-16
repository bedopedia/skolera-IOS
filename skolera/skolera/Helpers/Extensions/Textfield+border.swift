//
//  Textfield+border.swift
//  skolera
//
//  Created by Ismail Ahmed on 1/24/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit
///extenion to add the bottom border to TextField
extension UITextField {
    
    func underlined() {
        self.layoutIfNeeded()
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.appColors.greyTextField.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.bounds.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        debugPrint("y", self.frame.size.height - width, "width", self.bounds.width, "height", self.frame.size.height)
    }
    func active()
    {
        
        self.layer.sublayers![0].borderColor = UIColor.appColors.green.cgColor
    }
    func inactive()
    {
        self.layer.sublayers![0].borderColor = UIColor.appColors.greyTextField.cgColor
    }
}
