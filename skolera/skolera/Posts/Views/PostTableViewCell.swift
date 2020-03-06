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
    
    
    var openAttachment: (() -> ())!
    var post: Post! {
        didSet {
            if post != nil {
                postOwner.text = post.owner?.nameWithTitle
             
                postContent.update(input: post.content ?? "")
                
                firstAttachmentView.isHidden = false
                secondAttachmentView.isHidden = false
                thirdAttachmentView.isHidden = false
                if let files = post.uploadedFiles, !files.isEmpty {
                    attachmentHeightConstraint.constant = 60
                    attachmentView.isHidden = false
                    if files.count == 1 {
                        firstAttachmentView.isHidden = false
                        firstAttachment.text = files[0].name
                    } else if files.count == 2 {
                        firstAttachmentView.isHidden = false
                        firstAttachment.text = files[0].name
                        secondAttachmentView.isHidden = false
                        secondAttachment.text = files[1].name
                    } else {
                        firstAttachmentView.isHidden = false
                        firstAttachment.text = files[0].name
                        secondAttachmentView.isHidden = false
                        secondAttachment.text = files[1].name
                        thirdAttachmentView.isHidden = false
                        thirdAttachment.text = "\(files.count - 2)"
                    }
                } else {
                    attachmentHeightConstraint.constant = 10
                    attachmentView.isHidden = true
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000'Z'"
                let postUpdateDate = dateFormatter.date(from: post.updatedAt!)
                let newDateFormat = DateFormatter()
                newDateFormat.dateFormat = "dd MMM YYYY"
                if Language.language == .arabic {
                    postDate.text = "اخر تعديل " + newDateFormat.string(from: postUpdateDate!)
                } else {
                    postDate.text = "Last Updated \(newDateFormat.string(from: postUpdateDate!))"
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
    
    @IBAction func openAttachments() {
        openAttachment()
    }

}
