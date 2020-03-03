//
//  UITextField+Views.swift
//  skolera
//
//  Created by Rana Hossam on 11/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    enum ViewType {
        case left, right
    }
    func setView(_ type: ViewType, with view: UIView) {
        if type == ViewType.left {
            leftView = view
            leftViewMode = .always
        } else if type == .right {
            rightView = view
            rightViewMode = .always
        }
    }
    func setView(_ view: ViewType, image: UIImage?, width: CGFloat = 50) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
        button.setImage(image, for: .normal)
        button.imageView!.contentMode = .scaleAspectFit
        setView(view, with: button)
        return button
    }
}
