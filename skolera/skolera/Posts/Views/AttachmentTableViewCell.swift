//
//  AttachmentTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class AttachmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attachmentImage: UIImageView!
    @IBOutlet weak var attachmentTitle: UILabel!
    @IBOutlet weak var attachmentDate: UILabel!
    
    var uploadedFile: UploadedFile! {
        didSet {
            if uploadedFile != nil {
                var image = UIImage()
                if uploadedFile.extensionField == nil {
                    image = UIImage(named: "file_icon")!
                } else if uploadedFile.extensionField!.elementsEqual("pdf") {
                    image = UIImage(named: "pdf_icon")!
                } else if uploadedFile.extensionField!.contains("doc") {
                    image = UIImage(named: "doc_icon")!
                } else if uploadedFile.extensionField!.contains("pp") {
                    image = UIImage(named: "ppt_icon")!
                } else if uploadedFile.extensionField!.contains("xl") {
                    image = UIImage(named: "xlsx_icon")!
                } else if uploadedFile.extensionField!.elementsEqual("rar") || uploadedFile.extensionField!.elementsEqual("zip") {
                    image = UIImage(named: "zip_icon")!
                } else if uploadedFile.extensionField!.elementsEqual("mp3") || uploadedFile.extensionField!.elementsEqual("wav") {
                    image = UIImage(named: "audio_icon")!
                } else if uploadedFile.extensionField!.elementsEqual("mp4") || uploadedFile.extensionField!.elementsEqual("3gp") {
                    image = UIImage(named: "video_icon")!
                } else {
                    image = UIImage(named: "file_icon")!
                }
                attachmentImage.image = image
                attachmentTitle.text = uploadedFile.name
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let fileDate = dateFormatter.date(from: uploadedFile.updatedAt!)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "dd MMM YYYY"
                attachmentDate.text = newDateFormat.string(from: fileDate!)
                
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
