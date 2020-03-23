//
//  String+convertHTML.swift
//  skolera
//
//  Created by Yehia Beram on 5/21/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import Foundation
import UIKit
extension String {
    var htmlToAttributedString: NSAttributedString? {
//        var dict:NSDictionary?
//        dict = NSMutableDictionary()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 4.0
        paragraphStyle.alignment = .center
//        guard let data = htmlCSSString.data(using: .utf8) else { return NSAttributedString() }
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
            
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else { return nil }
        return html
    }
}
