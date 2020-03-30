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
    
    //MARK: - Variables
    
    /// grade object acts as the cell data source. Once set, it fills the cell with its contents
    var courseGroup: ShortCourseGroup!{
            didSet{
                if courseGroup != nil{
                    courseNameLabel.text = courseGroup.courseName ?? ""
                    courseGradeLabel.isHidden = true
                    let courseName = self.courseGroup.courseName?.components(separatedBy: " ")
                    if let name = courseName, name.count == 1 {
                        courseImageView.childImageView(url: "\(name[0].first ?? Character(" "))", placeholder: "\(name[0].first ?? Character(" "))", textSize: 20)
                    } else {
                         courseImageView.childImageView(url: "\(courseName?[0].first ?? Character(" "))\(courseName?[1].first ?? Character(" "))", placeholder: "\(courseName?[0].first ?? Character(" "))\(courseName?[1].first ?? Character(" "))", textSize: 20)
                    }
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
    
    override func prepareForReuse() {
        courseImageView.childImageView(url: "" , placeholder: "", textSize: 20, borderWidth: 0)
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
