//
//  TabsTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 3/5/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TabsTableViewCell: UITableViewCell {

    @IBOutlet weak var tabsCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabsCollectionView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabCollectionViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

