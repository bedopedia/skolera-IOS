//
//  ActorViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/9/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import KeychainSwift

class ActorViewController: UIViewController {
    
    @IBOutlet weak var childImageOuterView: UIView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childGradeLabel: UILabel!
    @IBOutlet weak var notificationButton: UIBarButtonItem!

    
    var actorTableViewController: ActorFeaturesTableViewController!
    
    var actor: Actor! {
        didSet {
            if actor != nil {
                addActorImage()
                childNameLabel.text = actor.name
                childGradeLabel.text = actor.actableType
                for child in childViewControllers {
                    if let actorTableViewController = child as? ActorFeaturesTableViewController {
                        actorTableViewController.actor = self.actor
                        self.actorTableViewController = actorTableViewController
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        let alert = UIAlertController(title: "Settings".localized, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Switch Language to Arabic".localized, style: .default , handler:{ (UIAlertAction)in
            if Language.language == .arabic {
                self.showChangeLanguageConfirmation(language: .english)
            } else{
                self.showChangeLanguageConfirmation(language: .arabic)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Logout".localized, style: .destructive , handler:{ (UIAlertAction)in
            if(SVProgressHUD.isVisible())
            {
                SVProgressHUD.dismiss()
            }
            self.actorTableViewController.sendFCM(token: "")
            let keychain = KeychainSwift()
            keychain.clear()
            let nvc = UINavigationController()
            let schoolCodeVC = SchoolCodeViewController.instantiate(fromAppStoryboard: .Login)
            nvc.pushViewController(schoolCodeVC, animated: true)
            self.present(nvc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    func showChangeLanguageConfirmation(language: Language){
        let alert = UIAlertController(title: "Restart Required".localized, message: "This requires restarting the Application.\nAre you sure you want to close the app now?".localized, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES".localized, style: .default, handler: { action in
            Language.language = language
            exit(0);
        }))
        alert.addAction(UIAlertAction(title: "NO".localized, style: .default, handler: { action in
            // do nothing
        }))
        self.present(alert, animated: true, completion: nil)
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
