//
//  ChildProfileViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/27/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import Firebase
import SkeletonView

class ChildProfileViewController: UIViewController, NVActivityIndicatorViewable, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    //MARK: - Outlets
    
//    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    @IBOutlet weak var childImageOuterView: UIView!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childGradeLabel: UILabel!
    @IBOutlet weak var quizzesLabel: UILabel!
    @IBOutlet weak var assignmentsLabel: UILabel!
    @IBOutlet weak var eventsLabel: UILabel!
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    var child: Child!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!
    let maxHeight: CGFloat = 160
    let minHeight: CGFloat = 12
    
    //MARK: - Life Cycle
    
   
    /// sets basic screen details, sends current child to embedded ChildProfileFeaturesTableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        headerHeightConstraint.constant =  UIApplication.shared.statusBarFrame.height + 60
        backButton.setImage(backButton.image(for: .normal)?.flipIfNeeded(), for: .normal)
        if !isParent() {
            backButton.isHidden = true
            if let featureTVC = childViewControllers[0] as? ChildProfileFeaturesTableViewController {
                featureTVC.tableView.showAnimatedSkeleton()
            }
            setLocalization()
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    print("Error fetching remote instange ID: \(error)")
                } else if let result = result {
                    print("Remote instance ID token: \(result.token)")
                    self.sendFCM(token: result.token)
                    debugPrint(result.token)
                }
            }
        }
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
//        updateTabBarItem(tab: .home, tabBarItem: tabBarItem)
        self.addChildImage()
        self.addChildData()
    }
  
    
//        
//        @IBAction func leftAction() {
//            if isParent() {
//                self.navigationController?.popViewController(animated: true)
//            } else {
//                openNewMessage()
//            }
//        }
//        
//        @IBAction func rightAction() {
//            if isParent() {
//                openNewMessage()
//            } else {
//                openSettings()
//            }
//        }
//    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let enable = self.navigationController?.viewControllers.count ?? 0 > 1
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    @IBAction func settingsButton() {
        
        let parentController = parent?.parent
        if let mainViewController = parentController as? TabBarViewController {
            mainViewController.openSettings()
        }
    }
    
    @IBAction func backAction() {
        self.parent?.navigationController?.popViewController(animated: true)
//        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - methods
    
    /// draws the child image with rounded green glow
    func addChildImage()
    {
        //sets outer view to generate the green glow
        childImageOuterView.clipsToBounds = false
        childImageOuterView.layer.shadowColor = UIColor.appColors.green.cgColor
        childImageOuterView.layer.shadowOpacity = 0.5
        childImageOuterView.layer.shadowOffset = CGSize.zero
        childImageOuterView.layer.shadowRadius = 10
        childImageOuterView.layer.shadowPath = UIBezierPath(roundedRect:  childImageOuterView.bounds, cornerRadius: childImageOuterView.frame.height/2 ).cgPath
        //gets inner child image view
        let childImageView = UIImageView(frame: childImageOuterView.bounds)
        childImageView.childImageView(url: child.avatarUrl, placeholder: "\(child.firstname.first!)\(child.lastname.first!)", textSize: 32)
        childImageOuterView.backgroundColor = nil
        childImageOuterView.addSubview(childImageView)
        //sets image frame to the outer frame
        NSLayoutConstraint.activate([childImageView.leadingAnchor.constraint(equalTo: childImageOuterView.leadingAnchor),childImageView.topAnchor.constraint(equalTo: childImageOuterView.topAnchor)])
    }
    
    func addChildData() {
        if let child = child{
            childNameLabel.text = child.name
            childGradeLabel.text = child.levelName
        }
//        if let assignmentsText = assignmentsText{
//            assignmentsLabel.text = assignmentsText
//        }
//        if let quizzesText = quizzesText{
//            quizzesLabel.text = quizzesText
//        }
//        if let eventsText = eventsText{
//            eventsLabel.text = eventsText
//        }
        let featureTVC = childViewControllers[0] as! ChildProfileFeaturesTableViewController
        featureTVC.child = child
        featureTVC.scrollHandler = { y in
            let newHeaderViewHeight: CGFloat = self.heightConstraint.constant - y
            if newHeaderViewHeight > self.maxHeight {
                self.heightConstraint.constant = self.maxHeight
            } else if newHeaderViewHeight < self.minHeight{
                self.heightConstraint.constant = self.minHeight
            } else {
                self.heightConstraint.constant = newHeaderViewHeight
            }
        }
    }

    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        let notificationsVC = NotificationsViewController.instantiate(fromAppStoryboard: .HomeScreen)
        let nvc = UINavigationController(rootViewController: notificationsVC)
        nvc.modalPresentationStyle = .fullScreen
        self.present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func openAssignments(){
        let assignmentsVC = AssignmentCoursesViewController.instantiate(fromAppStoryboard: .Assignments)
        assignmentsVC.child = self.child
        self.navigationController?.pushViewController(assignmentsVC, animated: true)
    }
    
    @IBAction func openThreads(){
        
        if let threadsNvc = childViewControllers[0] as? ContactTeacherNVC {
            let threadsVC = ContactTeacherViewController.instantiate(fromAppStoryboard: .Threads)
            threadsVC.child = self.child
//            self.navigationController?.pushViewController(threadsVC, animated: true)
            threadsNvc.pushViewController(threadsVC, animated: true)
        }
  
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
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    

    
    func sendFCM(token: String) {
//        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
//            self.stopAnimating()
            if isSuccess {
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    //service call to change localization
    func setLocalization() {
//        startAnimating(CGSize(width: 150, height: 150), message: "", type: .ballScaleMultiple, color: getMainColor(), backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5), fadeInAnimation: nil)
        var locale = ""
        if Locale.current.languageCode!.elementsEqual("ar") {
            locale = "ar"
        } else {
            locale = "en"
        }
        let parameters: Parameters = ["user": ["language": locale]]
        let headers : HTTPHeaders? = getHeaders()
        let url = String(format: EDIT_USER(), userId())
        Alamofire.request(url, method: .put, parameters: parameters, headers: headers).validate().responseJSON { response in
//            self.stopAnimating()
            switch response.result{
            case .success(_):
                //do nothing
                debugPrint("success")
            case .failure(let error):
                print(error.localizedDescription)
                if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet
                {
                    showAlert(viewController: self, title: ERROR, message: NO_INTERNET, completion: {action in
                        })
                }
                else if response.response?.statusCode == 401 || response.response?.statusCode == 500
                {
                    showReauthenticateAlert(viewController: self)
                }
                else
                {
                    showAlert(viewController: self, title: ERROR, message: SOMETHING_WRONG, completion: {action in
                        })
                }
            }
        }
    }

}
