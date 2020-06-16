//
//  AnnouncementTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 1/14/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    //    @IBOutlet weak var itemBody: UILabel!
    @IBOutlet weak var itemDate: UILabel!
    
    var announcement: Announcement! {
        didSet{
            //cell title and child name(if any)
            itemTitle.text = announcement.title
            //            itemBody.text = announcement.body.htmlToString.replacingOccurrences(of: "\n", with: " ")
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let date = dateFormatter.date(from: announcement.endAt)!
            dateFormatter.dateFormat = "dd MMM yyyy"
            debugPrint(date)
            //showing date
            itemDate.text = dateFormatter.string(from: date)
            if let image = announcement.imageURL, !image.isEmpty {
                itemImage.childImageView(url: image, placeholder: "", textSize: 16)
            } else {
                itemImage.image = nil
                itemImage.childImageView(url: "", placeholder: "\(announcement.title.capitalizingFirstLetter().first!)", textSize: 16)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
