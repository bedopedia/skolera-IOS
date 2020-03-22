//
//  WeeklyPlannerViewController.swift
//  skolera
//
//  Created by Yehia Beram on 3/3/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire

class WeeklyPlannerViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var contianerView: UIView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weeklyNoteImage: UIImageView!
    @IBOutlet weak var weeklyNoteTitleLabel: UILabel!
    @IBOutlet weak var weeklyNoteLabel: UILabel!
    @IBOutlet weak var weeklyNoteImageConstraint: NSLayoutConstraint!
    @IBOutlet weak var weeklyNoteBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreFrame: CustomGradientView!
    @IBOutlet var placeHolderView: UIView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var topHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topHeaderCenterYConstraints: NSLayoutConstraint!
    
    var child : Actor!
    
    var maxHeaderHeight: CGFloat = 395
    let minHeaderHeight: CGFloat = 50
    var previousScrollOffset: CGFloat = 0
    var weeklyPlanner: WeeklyPlan!
//    var dailyNotes: [String: [DailyNote]] = ["Saturday":[],
//                                             "Sunday": [],
//                                             "Monday": [],
//                                             "Tuesday": [],
//                                             "Wednesday": [],
//                                             "Thursday": [],
//                                             "Friday": []]
    var dailyNotes: [String: [DailyNote]] = [:]
    var dateStrings: [String] = []
    var activeDays: [String] = []
    var selectedDay: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        topHeaderHeightConstraint.constant = UIApplication.shared.statusBarFrame.height + 60
        topHeaderCenterYConstraints.constant = UIApplication.shared.statusBarFrame.height/2
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        if weeklyPlanner != nil {
            if weeklyPlanner.dailyNotes.isEmpty {
                maxHeaderHeight = 50
                headerHeightConstraint.constant = 50
                
            } else {
                placeHolderView.isHidden = true
                if let url = URL(string: weeklyPlanner.generalNote.image ?? "") {
                    weeklyNoteImage.kf.setImage(with: url, options: [.memoryCacheExpiration(.seconds(1))])
                } else {
                    weeklyNoteImage.isHidden = true
                    weeklyNoteImageConstraint.constant = 0
                    containerViewHeightConstraint.constant = 159
                    maxHeaderHeight = 249
                    headerHeightConstraint.constant = 249
                }
                weeklyNoteTitleLabel.text = weeklyPlanner.generalNote.title
                weeklyNoteLabel.text = (weeklyPlanner.generalNote.description).replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<P>", with: "\n").htmlToString
                weeklyNoteLabel.sizeToFit()
            }
        } else {
            placeHolderView.isHidden = false
        }
        
        contianerView.layer.masksToBounds = false
        contianerView.layer.shadowColor = UIColor.black.cgColor
        contianerView.layer.shadowOffset = CGSize(width: 0, height: 2);
        contianerView.layer.shadowOpacity = 0.08
        
        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
        customView.backgroundColor = UIColor.clear
        tableView.tableFooterView = customView
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabCollectionViewCell")
        
        
        if weeklyPlanner != nil {
            getDatesOfWeeklyPlanner()
            for date in dateStrings {
                if let myDailyNotes = self.weeklyPlanner.dailyNotes[date] {
                    dailyNotes[date] = myDailyNotes
                    self.activeDays.append(date)
                }
            }
        }

        self.collectionView.reloadData()
        
        tableView.delegate = self
        tableView.dataSource  = self
    }
    
    func getDatesOfWeeklyPlanner() {
         let dateFormatter = DateFormatter()
               dateFormatter.locale = Locale(identifier: "en")
               dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: weeklyPlanner.startDate)!
        let endDate = dateFormatter.date(from: weeklyPlanner.endDate)!

        var date = startDate
        while date <= endDate {
            dateStrings.append(dateFormatter.string(from: date))
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        }
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func seeMore(){
        let announcementsVc = 
            AnnouncementViewController.instantiate(fromAppStoryboard: .Announcements)
        announcementsVc.weeklyNote = self.weeklyPlanner.generalNote
        announcementsVc.child = self.child
        self.navigationController?.pushViewController(announcementsVc, animated: true)
    }
}

extension WeeklyPlannerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weeklyPlanner != nil {
            return self.dailyNotes[self.activeDays[selectedDay]]!.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseGradeCell", for: indexPath) as! CourseGradeCell
        let item = self.dailyNotes[self.activeDays[selectedDay]]![indexPath.row]
        cell.courseNameLabel.text = item.title
        let courseName = item.title.components(separatedBy: " ")
        if  courseName.count == 1 {
            cell.courseImageView.childImageView(url: "\(courseName[0].first ?? Character(""))", placeholder: "\(courseName[0].first ?? Character(""))", textSize: 20)
        } else {
            cell.courseImageView.childImageView(url: "\(courseName[0].first ?? Character(""))\(courseName[1].first ?? Character(""))", placeholder: "\(courseName[0].first ?? Character(""))\(courseName[1].first ?? Character(""))", textSize: 20)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SubjectWeeklyPlanViewController.instantiate(fromAppStoryboard: .WeeklyReport)
        vc.dailyNote = self.dailyNotes[self.activeDays[selectedDay]]![indexPath.row]
        vc.child = self.child
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        let absoluteTop: CGFloat = 0
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y <= 0
        if canAnimateHeader(scrollView) {
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if weeklyPlanner != nil {
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                if isScrollingUp {
                    self.expandHeader()
                    self.setScrollPosition(0)
                } else {
                    self.setScrollPosition(self.previousScrollOffset)
                }
            }
            }
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    public func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
}

extension WeeklyPlannerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activeDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
        cell.dayLabel.text = getDateByName(date: self.activeDays[indexPath.row])
        if indexPath.row == selectedDay {
            cell.selectDay()
        } else {
            cell.deSelectDay()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDay = indexPath.row
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    
}

class ArabicCollectionFlow: UICollectionViewFlowLayout {
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return Language.language == .arabic
    }
}
