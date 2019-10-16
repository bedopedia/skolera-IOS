//
//  ChildProfileFeaturesNVC.swift
//  skolera
//
//  Created by Rana Hossam on 9/10/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit

class ChildProfileFeaturesNVC: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavigationBarHidden = true
//        self.delegate = self
//        self.interactivePopGestureRecognizer?.delegate = self
    }
    // MARK: - Swipe
//    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
//    }
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
