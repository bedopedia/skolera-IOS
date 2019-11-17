//
//  PlaceholderView.swift
//  skolera
//
//  Created by Rana Hossam on 11/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class PlaceholderView: UIView {

    @IBOutlet var placeholderImageView: UIImageView!
    @IBOutlet var placeholderLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    func commonInit() {
        let bundle = Bundle.init(for: PlaceholderView.self)
        if let viewsToAdd = bundle.loadNibNamed("PlaceholderView", owner: self, options: nil), let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight,
                                            .flexibleWidth]
        }
    }

}
