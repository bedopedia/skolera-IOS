//
//  String+CapitalizeFirstLetter.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/17/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    mutating func withoutHTMLTags()-> String
    {
        let htmlStringData = self.data(using: String.Encoding.utf8)!
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
        ]
        let attributedString = try! NSAttributedString(data: htmlStringData, options: options, documentAttributes: nil)
        self = attributedString.string
        return self
    }
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    func decode() -> String {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII) ?? self
    }

}
