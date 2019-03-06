//
//  WeeklyPlannerViewController.swift
//  skolera
//
//  Created by Yehia Beram on 3/3/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class WeeklyPlannerViewController: UIViewController {

    @IBOutlet weak var contianerView: UIView!
    @IBOutlet weak var childImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var weeklyNoteImage: UIImageView!
    @IBOutlet weak var weeklyNoteTitleLabel: UILabel!
    @IBOutlet weak var weeklyNoteLabel: UILabel!
    @IBOutlet weak var weeklyNoteBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var seeMoreFrame: CustomGradientView!
    
    var child : Child!
    
    var maxHeaderHeight: CGFloat = 395
    let minHeaderHeight: CGFloat = 50
    var previousScrollOffset: CGFloat = 0
    
    var weeklyPlanner: WeeklyPlan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.barTintColor = .white
        if let child = child{
            childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 14)
        }
        if weeklyPlanner.weeklyNotes.isEmpty {
            maxHeaderHeight = 50
            headerHeightConstraint.constant = 50
        } else {
            if let url = URL(string: weeklyPlanner.weeklyNotes.first?.imageUrl ?? "") {
                weeklyNoteImage.kf.setImage(with: url)
            } else {
                weeklyNoteImage.isHidden = true
            }
            weeklyNoteTitleLabel.text = weeklyPlanner.weeklyNotes.first?.title ?? ""
            weeklyNoteLabel.text = weeklyPlanner.weeklyNotes.first?.descriptionField ?? ""
            weeklyNoteLabel.sizeToFit()
            
            if weeklyNoteLabel.frame.height >= 84 {
                seeMoreFrame.isHidden = false
            } else {
                seeMoreFrame.isHidden = true
            }
            
        }
        contianerView.layer.masksToBounds = false
        contianerView.layer.shadowColor = UIColor.black.cgColor
        contianerView.layer.shadowOffset = CGSize(width: 0, height: 2);
        contianerView.layer.shadowOpacity = 0.08
        
        tableView.delegate = self
        tableView.dataSource  = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "TabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TabCollectionViewCell")
    }
    
    @IBAction func seeMore(){
        
    }
}

extension WeeklyPlannerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseGradeCell", for: indexPath) as! CourseGradeCell
        
//        cell.grade = grades[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(SubjectWeeklyPlanViewController.instantiate(fromAppStoryboard: .WeeklyReport), animated: true)
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
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                if isScrollingUp {
                    self.expandHeader()
                    self.setScrollPosition(0)
                } else {
                    self.setScrollPosition(self.previousScrollOffset)
                    self.updateHeader()
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
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
//        let range = self.maxHeaderHeight - self.minHeaderHeight
//        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
//        let percentage = openAmount / range
//        titleLabel.alpha = percentage
    }
}

extension WeeklyPlannerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TabCollectionViewCell", for: indexPath) as! TabCollectionViewCell
        if indexPath.row == 0 {
            cell.selectDay()
        } else {
            cell.deSelectDay()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 50)
    }
    
    
    
}

class ArabicCollectionFlow: UICollectionViewFlowLayout {
    override var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return Language.language == .arabic
    }
}
