//
//  UIImage+StudentImage.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/27/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
///get the circular view with a green border
extension UIImageView {
    func childImageView(url : String, placeholder: String, textSize: Int, backgroundColor: UIColor = UIColor.appColors.green)
    {
        // setting up placeholder
        let temp = UILabel()
        temp.textAlignment = .center
        temp.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: backgroundColor)
        temp.font = UIFont.systemFont(ofSize: CGFloat(textSize), weight: UIFont.Weight.semibold)
        temp.text = placeholder
        //setting student image view to circle with green border
        self.kf.setImage(with: getChildImageURL(urlString: url), placeholder: temp)
        setChildImageViewToCircle()
    }
    
    fileprivate func setChildImageViewToCircle() {
        self.layer.borderWidth = 2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.appColors.green.cgColor
        self.layer.cornerRadius = self.frame.height/2
    }
}

extension UIImage {
    public func flippedImage() -> UIImage?{
        if let _cgImag = self.cgImage {
            let flippedimg = UIImage(cgImage: _cgImag, scale:self.scale , orientation: UIImageOrientation.upMirrored)
            return flippedimg
        }
        return nil
    }
    
    public func flipIfNeeded() -> UIImage? {
        if (Locale.current.languageCode?.elementsEqual("ar"))! {
            return self.flippedImage()
        }
        return self
    }
}
