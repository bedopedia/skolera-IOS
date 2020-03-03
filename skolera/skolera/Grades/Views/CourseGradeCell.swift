//
//  CourseGradeCell.swift
//  skolera
//
//  Created by Ismail Ahmed on 3/4/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit

class CourseGradeCell: UITableViewCell {

    //TODO:- COURSES ICONS REMAINING
    //MARK: - Outlets
    @IBOutlet weak var courseImageView: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseGradeLabel: UILabel!
    @IBOutlet weak var subjectImageLabel: UILabel!
    
    //MARK: - Variables
    
    /// grade object acts as the cell data source. Once set, it fills the cell with its contents
    var courseGroup: ShortCourseGroup!{
            didSet{
                if courseGroup != nil{
                    courseNameLabel.text = courseGroup.courseName ?? ""
                    courseGradeLabel.isHidden = true
                    courseGradeLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: UIColor.appColors.green)
                    courseImageView.isHidden = false
                    subjectImageLabel.clipsToBounds = false
                    
                    courseImageView.layer.shadowColor = UIColor.appColors.green.cgColor
                    courseImageView.layer.shadowOpacity = 0.3
                    courseImageView.layer.shadowOffset = CGSize.zero
                    courseImageView.layer.shadowRadius = 10
                    courseImageView.layer.shadowPath = UIBezierPath(roundedRect: courseImageView.bounds, cornerRadius: courseImageView.frame.height/2 ).cgPath
                    let courseName = self.courseGroup.courseName?.split(separator: " ") as? [String]
                    if courseName?.count == 1 {
                        courseImageView.childImageView(url: "", placeholder: "\(self.courseGroup.courseName?.dropFirst(1)))", textSize: 14)
                    } else {
                        courseImageView.childImageView(url: "", placeholder: "\(courseName?.first?.first)\(courseName?[1].first))", textSize: 14)
                    }
                    subjectImageLabel.textAlignment = .center
                    subjectImageLabel.rounded(foregroundColor: UIColor.appColors.white, backgroundColor: UIColor.appColors.green)
                    subjectImageLabel.font = UIFont.systemFont(ofSize: CGFloat(18), weight: UIFont.Weight.semibold)
                    subjectImageLabel.text = getText(name: courseGroup.courseName ?? "")
                }
            }
        }
        
        func getText(name: String) -> String {
            let shortcut = name.replacingOccurrences(of: "&", with: "")
            if shortcut.split(separator: " ").count == 1 || (shortcut.split(separator: " ").count > 1 && shortcut.split(separator: " ")[1].first!.isPunctuation){
    //            return "\(shortcut.first!)"
                return String(shortcut.prefix(2))
            } else {
                    return "\(shortcut.split(separator: " ")[0].first!)\(shortcut.split(separator: " ")[1].first!)"
            }
            
        }
        //MARK: - Life Cycle
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        private func getCourseImage(courseName: String) -> UIImage {
            if courseName.contains("English") {
                return UIImage(named: "english")!
            } else if courseName.contains("Mathematics") {
                return UIImage(named: "Algabra")!
            } else if courseName.contains("Social Studies") {
                return UIImage(named: "social studies")!
            } else if courseName.contains("Science") {
                return UIImage(named: "science")!
            } else if courseName.contains("French") {
                return UIImage(named: "french")!
            } else if courseName.contains("Arabic") {
                return UIImage(named: "Arabic")!
            } else if courseName.contains("National Studies") {
                return UIImage(named: "national studies")!
            } else if courseName.contains("Art") {
                return UIImage(named: "Language Arts")!
            } else if courseName.contains("Computer") {
                return UIImage(named: "computer")!
            } else if courseName.contains("Islamic Studies") {
                return UIImage(named: "Religion")!
            } else if courseName.contains("Christian Studies") {
                return UIImage(named: "Religion")!
            } else if courseName.contains("Physical Education") {
                return UIImage(named: "PE")!
            } else if courseName.contains("Music") {
                return UIImage(named: "music")!
            } else if courseName.contains("Advisement") {
                return UIImage(named: "Advisement")!
            } else if courseName.contains("Cookery") {
                return UIImage(named: "Cookery")!
            }
            return UIImage()
        }
        
        

    }
