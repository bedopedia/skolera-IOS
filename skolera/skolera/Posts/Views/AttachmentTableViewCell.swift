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
    @IBOutlet weak var cancelButton: UIButton!
    
    var cancelAction: (() -> ())!
    
    var uploadedFile: UploadedFile! {
        didSet {
            if uploadedFile != nil {
                var image = UIImage()
                if uploadedFile.extensionField == nil {
                    image = UIImage(named: "file_icon")!
                } else if uploadedFile.extensionField!.elementsEqual("pdf") {
                    image = UIImage(named: "pdf_icon")!
                } else if uploadedFile.extensionField!.contains("doc") || uploadedFile.extensionField!.contains("rtf")  {
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
//                attachmentDate.text = newDateFormat.string(from: fileDate!)
                if let size = self.uploadedFile.fileSize {
                    attachmentDate.text = getSizeString(size: Double(size))
                }
                
            }
        }
    }
    
    var chosenFile: URL! {
        didSet {
            if chosenFile != nil {
                var image = UIImage()
                if chosenFile.pathExtension.isEmpty {
                    image = UIImage(named: "file_icon")!
                } else if chosenFile.pathExtension.elementsEqual("pdf") {
                    image = UIImage(named: "pdf_icon")!
                } else if chosenFile.pathExtension.contains("doc") || chosenFile.pathExtension.contains("rtf") {
                    image = UIImage(named: "doc_icon")!
                } else if chosenFile.pathExtension.contains("pp") {
                    image = UIImage(named: "ppt_icon")!
                } else if chosenFile.pathExtension.contains("xl") {
                    image = UIImage(named: "xlsx_icon")!
                } else if chosenFile.pathExtension.elementsEqual("rar") || chosenFile.pathExtension.elementsEqual("zip") {
                    image = UIImage(named: "zip_icon")!
                } else if chosenFile.pathExtension.elementsEqual("mp3") || chosenFile.pathExtension.elementsEqual("wav") {
                    image = UIImage(named: "audio_icon")!
                } else if chosenFile.pathExtension.elementsEqual("mp4") || chosenFile.pathExtension.elementsEqual("3gp") {
                    image = UIImage(named: "video_icon")!
                } 
                else {
                    image = UIImage(named: "file_icon")!
                    debugPrint("other file type")
                }
            
                if attachmentImage != nil {
                    attachmentImage.image = image
                } else {
                    debugPrint("attachment image = nil")
                }
                attachmentTitle.text = chosenFile.lastPathComponent
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
//                let fileDate = dateFormatter.date(from: uploadedFile.updatedAt!)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "dd MMM YYYY"
                attachmentDate.text = newDateFormat.string(from: Date())
            }
        }
    }
    
    @IBAction func cancelSelection() {
        cancelAction()
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getSizeString(size: Double) -> String {
        var fileSize: Double = 0
        if size > (1000 * 1000) {
            fileSize = size / (1000 * 1000)
            fileSize = Double(round(100*fileSize)/100)
            return "\(fileSize) MB"
        } else {
            fileSize = size / (1000)
            fileSize = Double(round(100*fileSize)/100)
            return "\(fileSize) KB"
        }
    }

}
