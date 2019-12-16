//
//  ActorViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/9/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ActorViewController: UIViewController, NVActivityIndicatorViewable, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var childImageOuterView: UIView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childGradeLabel: UILabel!
    @IBOutlet weak var notificationButton: UIBarButtonItem!

    
    var actorTableViewController: ActorFeaturesTableViewController!
    
    var actor: Actor! {
        didSet {
//            if actor != nil {
//                addActorImage()
//                childNameLabel.text = actor.name
//                childGradeLabel.text = actor.actableType
//                for child in childViewControllers {
//                    if let actorTableViewController = child as? ActorFeaturesTableViewController {
//                        actorTableViewController.actor = self.actor
//                        actorTableViewController.getTimeTable()
//                        self.actorTableViewController = actorTableViewController
//                    }
//                }
//            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        if actor != nil {
            addActorImage()
            childNameLabel.text = actor.name
            childGradeLabel.text = actor.actableType
            for child in childViewControllers {
                if let actorTableViewController = child as? ActorFeaturesTableViewController {
                    actorTableViewController.actor = self.actor
                    actorTableViewController.getTimeTable()
                    self.actorTableViewController = actorTableViewController
                }
            }
        }
    }

    
//    MARK: - Swipe
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    public func setActorData(actor: Actor) {
        self.actor = actor
    }
    
    private func addActorImage() {
        //sets outer view to generate the green glow
        childImageOuterView.clipsToBounds = false
        childImageOuterView.layer.shadowColor = UIColor.appColors.green.cgColor
        childImageOuterView.layer.shadowOpacity = 0.5
        childImageOuterView.layer.shadowOffset = CGSize.zero
        childImageOuterView.layer.shadowRadius = 10
        childImageOuterView.layer.shadowPath = UIBezierPath(roundedRect: childImageOuterView.bounds, cornerRadius: childImageOuterView.frame.height/2 ).cgPath
        //gets inner child image view
            let childImageView = UIImageView(frame: childImageOuterView.bounds)
            childImageView.childImageView(url: actor.avatarUrl, placeholder: "\(actor.firstname.first!)\(actor.lastname.first!)", textSize: 32)
            childImageOuterView.backgroundColor = nil
            childImageOuterView.addSubview(childImageView)
            //sets image frame to the outer frame
            NSLayoutConstraint.activate([childImageView.leadingAnchor.constraint(equalTo: childImageOuterView.leadingAnchor),childImageView.topAnchor.constraint(equalTo: childImageOuterView.topAnchor)])
    }
    
    @IBAction func logout() {
        let settingsVC = SettingsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        settingsVC.userId = actor.actableId
        navigationController?.pushViewController(settingsVC, animated: true)
    }
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
