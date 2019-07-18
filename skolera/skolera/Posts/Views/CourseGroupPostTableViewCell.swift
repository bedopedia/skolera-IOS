//
//  CourseGroupPostTableViewCell.swift
//  skolera
//
//  Created by Yehia Beram on 7/17/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class CourseGroupPostTableViewCell: UITableViewCell {

    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var subjectImageLabel: UILabel!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    
    var course: PostCourse!{
        didSet {
            if course != nil {
                courseImageView.isHidden = false
                subjectImageLabel.clipsToBounds = false
                courseImageView.layer.shadowColor = UIColor.appColors.green.cgColor
                courseImageView.layer.shadowOpacity = 0.3
                courseImageView.layer.shadowOffset = CGSize.zero
                courseImageView.layer.shadowRadius = 10
                courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
                subjectImageLabel.textAlignment = .center
                subjectImageLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: UIColor.appColors.green)
                subjectImageLabel.font = UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.semibold)
                subjectImageLabel.text = getText(name: course.courseName ?? "")
                courseTitle.text = course.courseName
                numberOfPostsLabel.text = "\(course.postsCount ?? 0)"
                teacherName.text = course.post?.owner?.nameWithTitle
                let htmlData = NSString(string: course.post?.content ?? "").data(using: String.Encoding.unicode.rawValue)
                let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                    NSAttributedString.DocumentType.html]
                let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
                                                                      options: options,
                                                                      documentAttributes: nil)
                postText.attributedText = attributedString
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
