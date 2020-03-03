//
//  SettingsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 12/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SettingsViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
//
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout() {
        navigationController?.popViewController(animated: true)
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
