//
//  PostTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/18/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import RichTextView
class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postOwner: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var attachmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstAttachmentView: UIView!
    @IBOutlet weak var firstAttachment: UILabel!
    @IBOutlet weak var secondAttachmentView: UIView!
    @IBOutlet weak var secondAttachment: UILabel!
    @IBOutlet weak var thirdAttachmentView: UIView!
    @IBOutlet weak var thirdAttachment: UILabel!
    @IBOutlet var postContent: RichTextView!
    @IBOutlet var gradientView: GradientView!
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var firstFileSize: UILabel!
    @IBOutlet var secondFileSize: UILabel!
    @IBOutlet var separatorView: UIView!
    
    var openAttachment: (() -> ())!
    var post: Post! {
        didSet {
            if post != nil {
                postOwner.text = post.owner?.nameWithTitle
                if let content = post.content, !content.isEmpty {
                    postContent.update(input: content)
                } else {
                    postContent.update(input: "No content available".localized)
                }
                postImageView.childImageView(url: self.post.owner?.avatarUrl ?? "", placeholder: "\(String(post.owner?.firstname?.first! ?? Character.init("")) )\(String(post.owner?.lastname?.first! ?? Character.init("")))", textSize: 14)
                firstAttachmentView.isHidden = true
                secondAttachmentView.isHidden = true
                thirdAttachmentView.isHidden = true
                if let files = post.uploadedFiles, !files.isEmpty {
                    attachmentHeightConstraint.constant = 60
                    attachmentView.isHidden = false
                    separatorView.isHidden = false
                    if files.count == 1 {
                        firstAttachmentView.isHidden = false
                        firstAttachment.text = files[0].name
                        if let size = files[0].fileSize {
                            firstFileSize.text = getSizeString(size: Double(size) / 8)
                        }
                    } else if files.count == 2 {
                        firstAttachmentView.isHidden = false
                        firstAttachment.text = files[0].name
                        secondAttachmentView.isHidden = false
                        secondAttachment.text = files[1].name
                        if let size = files[0].fileSize {
                            secondFileSize.text = getSizeString(size: Double(size) / 8)
                        }
                    } else {
                        firstAttachmentView.isHidden = false
                        firstAttachment.text = files[0].name
                        secondAttachmentView.isHidden = false
                        secondAttachment.text = files[1].name
                        thirdAttachmentView.isHidden = false
                        thirdAttachment.text = files[2].name
                    }
                } else {
                    attachmentHeightConstraint.constant = 10
                    attachmentView.isHidden = true
                    separatorView.isHidden = true
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let postUpdateDate = dateFormatter.date(from: post.updatedAt!)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "dd MMM 'at' HH:mm a"
                if Language.language == .arabic {
                    postDate.text = newDateFormat.string(from: postUpdateDate!)
                } else {
                    postDate.text = newDateFormat.string(from: postUpdateDate!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
//        attachmentView.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getSizeString(size: Double) -> String {
        var fileSize: Double = 0
        if size > (1024 * 1024) {
            fileSize = size / (1024 * 1024)
            fileSize = Double(round(100*fileSize)/100)
            return "\(fileSize) MB"
        } else {
            fileSize = size / (1024)
            fileSize = Double(round(100*fileSize)/100)
            return "\(fileSize) KB"
        }
    }
    
    @IBAction func openAttachments() {
        openAttachment()
    }

}
