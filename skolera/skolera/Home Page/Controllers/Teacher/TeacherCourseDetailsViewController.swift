//
//  TeacherCourseDetailsViewController.swift
//  skolera
//
//  Created by Yehia Beram on 7/29/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class TeacherCourseDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var courseGroup: CourseGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = courseGroup.name

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
        
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
