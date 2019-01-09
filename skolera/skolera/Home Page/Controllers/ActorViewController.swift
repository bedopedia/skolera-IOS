//
//  ActorViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/9/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class ActorViewController: UIViewController {
    
    @IBOutlet weak var childImageOuterView: UIView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childGradeLabel: UILabel!
    @IBOutlet weak var notificationButton: UIBarButtonItem!

    
    var actor: Parent!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        addActorImage()
        
        if let actor = actor{
            childNameLabel.text = actor.name
            childGradeLabel.text = actor.actableType
        }
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
