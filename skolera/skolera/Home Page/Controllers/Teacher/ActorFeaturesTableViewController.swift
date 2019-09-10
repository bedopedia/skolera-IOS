//
//  ActorFeaturesTableViewController.swift
//  skolera
//
//  Created by Yehia Beram on 1/9/19.
//  Copyright © 2019 Skolera. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import Firebase
import NRAppUpdate

class ActorFeaturesTableViewController: UITableViewController {
    
    var actor: Actor!
    var timeslots = [TimeSlot]()
    var disableTimeTable: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.sendFCM(token: result.token)
            }
        }
        
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
    
    func getTimeTable() {
        SVProgressHUD.show(withStatus: "Loading".localized)
        getTeacherTimeTableAPI(teacherActableId: actor.actableId!) { (isSuccess, statusCode, value, error) in
            SVProgressHUD.dismiss()
            if isSuccess {
                if let result = value as? [[String : AnyObject]], result.count > 0 {
                    for timeslotDictionary in result {
                        let timeslot = TimeSlot.init(fromDictionary: timeslotDictionary)
                        timeslot.day.capitalizeFirstLetter()
                        self.timeslots.append(timeslot)
                    }
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en")
                    self.timeslots.sort(by: { (a, b) -> Bool in
                        if dateFormatter.weekdaySymbols.index(of: a.day)! == dateFormatter.weekdaySymbols.index(of: b.day)! {
                            return a.from.time < b.from.time
                        } else {
                            return dateFormatter.weekdaySymbols.index(of: a.day)! < dateFormatter.weekdaySymbols.index(of: b.day)!
                        }
                    })
                    dateFormatter.dateFormat = "EEEE"
                    /////////////////////////////////////
//                    let now = Date()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd"
                    let now = formatter.date(from: "2019/07/01")!
                    ///////////////////////////////////////
                    var next = self.timeslots.first(where: { (a) -> Bool in
                        return a.day == dateFormatter.string(from: now) && now.time < a.from.time
                    })
                    if next == nil {
                        if let lasttimeSlottoday = self.timeslots.filter({ (a) -> Bool in
                            return a.day == dateFormatter.string(from: now)
                        }).last {
                            next = self.timeslots[(self.timeslots.index(of: lasttimeSlottoday)! + 1) % self.timeslots.count]
                        }
                    }
                    if next == nil {
                        next = self.timeslots.first!
                    }
                    self.disableTimeTable = false
                } else {
                    self.disableTimeTable = true
                }
            } else {
                showNetworkFailureError(viewController: self, statusCode: statusCode, error: error!)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var flag = false
        if indexPath.row == 0 {
            debugPrint("open timetable")
            for slot in timeslots {
                if let dateInSlot = slot.from, Calendar.current.isDateInToday(dateInSlot), Calendar.current.isDateInTomorrow(dateInSlot) {
                    flag = true
                    break;
                }
            }
            
            if !disableTimeTable {
                if flag {
                    let ttvc = TimetableViewController.instantiate(fromAppStoryboard: .Timetable)
                    ttvc.actor = actor
                    ttvc.timeslots = timeslots
                    self.navigationController?.pushViewController(ttvc, animated: true)
                } else {
                    let alert = UIAlertController(title: "Skolera".localized, message: "No timetable available".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
//        else if indexPath.row == 1 {
//            let threadsVC = ContactTeacherViewController.instantiate(fromAppStoryboard: .Threads)
////            threadsVC.child = self.child
//            
//            self.navigationController?.pushViewController(threadsVC, animated: true)
//        } else {
//            let announcementsVc = AnnouncementTableViewController.instantiate(fromAppStoryboard: .Announcements) //might need to be changed to open from the AnncouncementsTableViewNVC
//            
//            self.navigationController?.pushViewController(announcementsVc, animated: true)
//        }
    }
    
    
    
}
