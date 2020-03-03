//
//  HeaderShadow.swift
//  skolera
//
//  Created by Rana Hossam on 11/13/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class HeaderShadow: UIView {
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 2
    @IBInspectable var shadowColor: UIColor? = UIColor(red:136/255.0, green:167/255.0, blue:199/255.0,  alpha:1)
    @IBInspectable var shadowOpacity: Float = 0.21
    
    override func layoutSubviews() {
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
    }
    
}
