//
//  UIView+Shadow.swift
//  skolera
//
//  Created by Rana Hossam on 11/13/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow() {
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 2
        let shadowColor: UIColor? = UIColor(red:136/255.0, green:167/255.0, blue:199/255.0,  alpha:1)
        let shadowOpacity: Float = 0.21
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
    }
}
