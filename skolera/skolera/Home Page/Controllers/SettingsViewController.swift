//
//  SettingsViewController.swift
//  skolera
//
//  Created by Rana Hossam on 12/15/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout() {
//        self.dismiss(animated: true, completion: nil)
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

