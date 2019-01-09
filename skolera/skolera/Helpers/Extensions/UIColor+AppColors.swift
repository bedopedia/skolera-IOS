//
//  Colors.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/21/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    struct appColors {
        static var green : UIColor {return #colorLiteral(red: 0.1561536491, green: 0.7316914201, blue: 0.3043381572, alpha: 1) }
        static var white : UIColor {return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
        static var dark : UIColor {return #colorLiteral(red: 0.3456445932, green: 0.3459315896, blue: 0.3456890583, alpha: 1) }
        static var red : UIColor {return #colorLiteral(red: 1, green: 0.2078431373, blue: 0.3058823529, alpha: 1) }
        static var purple : UIColor {return #colorLiteral(red: 0.5843137255, green: 0.4588235294, blue: 0.8039215686, alpha: 1) }
        static var orange : UIColor {return #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1) }
        static var greyTextField : UIColor {return #colorLiteral(red: 0.5568627451, green: 0.5568627451, blue: 0.5764705882, alpha: 1) }
        static var greyNotTaken : UIColor {return #colorLiteral(red: 0.6901960784, green: 0.7450980392, blue: 0.7725490196, alpha: 1) }
        static var progressBarColor1 : UIColor {return #colorLiteral(red: 1, green: 0.368627451, blue: 0.2274509804, alpha: 1) }
        static var progressBarColor2 : UIColor {return #colorLiteral(red: 1, green: 0.5843137255, blue: 0, alpha: 1) }
        static var progressBarBackgroundColor : UIColor {return #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1) }
        static var offDaysColor: UIColor {return #colorLiteral(red: 0.6352941176, green: 0.6352941176, blue: 0.6352941176, alpha: 0.8) }
        static var timeSlotsColors : [UIColor]
        {
            return
            [
                #colorLiteral(red: 1, green: 0.6196078431, blue: 0.5019607843, alpha: 1),
                #colorLiteral(red: 1, green: 0.8980392157, blue: 0.4980392157, alpha: 1),
                #colorLiteral(red: 0.5176470588, green: 1, blue: 1, alpha: 1),
                #colorLiteral(red: 1, green: 0.5019607843, blue: 0.6705882353, alpha: 1),
                UIColor.appColors.green,
                #colorLiteral(red: 1, green: 0.368627451, blue: 0.2274509804, alpha: 1),
                #colorLiteral(red: 0.5490196078, green: 0.6196078431, blue: 1, alpha: 1),
                #colorLiteral(red: 0.5019607843, green: 0.8470588235, blue: 1, alpha: 1),
                #colorLiteral(red: 1, green: 0.7215686275, blue: 0.2666666667, alpha: 1),
                UIColor.appColors.red,
                UIColor.appColors.purple,
            ]
        }
    }
}
