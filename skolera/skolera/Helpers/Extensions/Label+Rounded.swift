//
//  Label+Rounded.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/5/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit
///rounded labels
extension UILabel{
    func rounded(foregroundColor : UIColor, backgroundColor: UIColor)
    {
        self.layer.masksToBounds = true
        self.backgroundColor = backgroundColor
        self.textColor = foregroundColor
        self.textAlignment = .center
        self.layer.cornerRadius = self.frame.height/2
    }
}
