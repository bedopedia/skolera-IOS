//
//  CourseGroupPostTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import RichTextView

class CourseGroupPostTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet var postContent: RichTextView!
    @IBOutlet var postContentTopConstraint: NSLayoutConstraint!
    
    var course: PostCourse!{
        didSet {
            if course != nil {
                courseImageView.isHidden = false
                subjectImageLabel.clipsToBounds = false

                subjectImageLabel.text = getText(name: course.courseName ?? "")
                courseTitle.text = course.courseName
                if let count = course.postsCount, count > 0 {
                    numberOfPostsLabel.text = "\(count)"
                } else {
                    numberOfPostsLabel.text = ""
                }
                if let name = course.post?.owner?.nameWithTitle, !name.isEmpty {
                    teacherName.text = name
                    postContentTopConstraint.constant = 4
                } else {
                    teacherName.text = "No recent posts currently".localized
                    postContentTopConstraint.constant = -16
                }
                postContent.update(input: course.post?.content ?? "")
            } else {
                courseImageView.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getText(name: String) -> String {
        let shortcut = name.replacingOccurrences(of: "&", with: "")
        if shortcut.split(separator: " ").count == 1 {
            //            return "\(shortcut.first!)"
            return String(shortcut.prefix(2))
        } else {
            return "\(shortcut.split(separator: " ")[0].first!)\(shortcut.split(separator: " ")[1].first!)"
        }
        
    }

}
