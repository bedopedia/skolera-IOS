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
    
    enum AngleUnit {
          /// degrees.
          case degrees
          /// radians.
          case radians
      }
    
    func addShadow() {
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 2
        let shadowColor: UIColor? = UIColor(red:136/255.0, green:167/255.0, blue:199/255.0,  alpha:1)
        let shadowOpacity: Float = 0.21
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
    }
    
    func rotate(byAngle angle: CGFloat, ofType type: AngleUnit, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        let angleWithType = (type == .degrees) ? .pi * angle / 180.0 : angle
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.transform = self.transform.rotated(by: angleWithType)
        }, completion: completion)
    }
}
