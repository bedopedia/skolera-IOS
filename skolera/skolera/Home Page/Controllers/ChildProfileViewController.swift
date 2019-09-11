//
//  ChildProfileViewController.swift
//  skolera
//
//  Created by Ismail Ahmed on 2/27/18.
//  Copyright © 2018 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import KeychainSwift
import Firebase

class ChildProfileViewController: UIViewController {

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
    
    //MARK: - Variables
    var child: Child!
    var assignmentsText : String!
    var quizzesText : String!
    var eventsText : String!
    
    let maxHeight: CGFloat = 138
    let minHeight: CGFloat = 12
    
    //MARK: - Life Cycle
    
    /// sets basic screen details, sends current child to embedded ChildProfileFeaturesTableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isParent() {
            let backItem = UIBarButtonItem()
            navigationItem.backBarButtonItem = backItem
        } else {
            let settingsItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "settings"), landscapeImagePhone: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(logout))
            settingsItem.tintColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
            navigationItem.leftBarButtonItem = settingsItem
            setLocalization()
            InstanceID.instanceID().instanceID { (result, error) in
                if let error = error {
                    print("Error fetching remote instange ID: \(error)")
                } else if let result = result {
                    print("Remote instance ID token: \(result.token)")
                    self.sendFCM(token: result.token)
                }
            }
        }
//        addChildImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let parentVC = parent?.parent as? ChildHomeViewController {
            parentVC.headerHeightConstraint.constant = 0
            parentVC.headerView.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint(parent?.parent)
        if let parentVC = parent?.parent as? ChildHomeViewController {
            parentVC.headerHeightConstraint.constant = 60 + UIApplication.shared.statusBarFrame.height
            parentVC.headerView.isHidden = false
        }
        
        
        //        notificationButton.image = UIImage(named: UIApplication.shared.applicationIconBadgeNumber == 0 ? "notifications" :  "unSeenNotification")?.withRenderingMode(.alwaysOriginal)
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
            debugPrint(y)
            ///////////////////
            let newHeaderViewHeight: CGFloat = self.heightConstraint.constant - y
            if newHeaderViewHeight > self.maxHeight {
                self.heightConstraint.constant = self.maxHeight
            } else if newHeaderViewHeight < self.minHeight{
                self.heightConstraint.constant = self.minHeight
            } else {
                self.heightConstraint.constant = newHeaderViewHeight
            }
            ////////////////////
            
        }
    }
    
    
    
    //MARK: - Actions
    
    /// show notification screen modally
    ///
    /// - Parameter sender: notification button
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        let notificationsTVC = NotificationsTableViewController.instantiate(fromAppStoryboard: .HomeScreen)
        let nvc = UINavigationController(rootViewController: notificationsTVC)
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
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func logout(_ sender: UIBarButtonItem) {
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
            self.sendFCM(token: "")
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
    
    func sendFCM(token: String) {
        SVProgressHUD.show(withStatus: "Loading".localized)
        let parameters: Parameters = ["user": ["mobile_device_token": token]]
        sendFCMTokenAPI(parameters: parameters) { (isSuccess, statusCode, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                debugPrint("UPDATED_FCM_SUCCESSFULLY")
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }
    
    //service call to change localization
    func setLocalization() {
        SVProgressHUD.show(withStatus: "Loading".localized)
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
            SVProgressHUD.dismiss()
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
